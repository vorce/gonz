defmodule Gonz.Navigation do
  @moduledoc """
  """

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/navigation.eex")
  end

  def docs(candidate_docs, opts) do
    include_index = Keyword.get(opts, :include_index, true)
    extra_docs = if include_index, do: [index_doc()], else: []

    (extra_docs ++ candidate_docs)
    |> Enum.filter(fn doc -> Enum.member?(doc.markdown.front_matter.categories, :nav_item) end)
    |> Enum.sort(fn a, b ->
      a.filename >= b.filename
    end)
  end

  def content(candidate_docs, theme, opts \\ [])
  def content([], _, _), do: ""

  def content(candidate_docs, theme, opts) do
    candidate_docs
    |> docs(opts)
    |> content_for(theme)
  end

  def content_for(nav_docs, theme) do
    # TODO: remove href_prefix completely from these assigns.
    with {:ok, nav_template} <- template(theme),
         assigns <- [items: nav_docs, href_prefix: "/"] do
      EEx.eval_string(nav_template, assigns: assigns)
    end
  end

  def index_doc() do
    %Gonz.Document{
      filename: "index.html",
      type: :index,
      markdown: %Gonz.Markdown{
        front_matter: %Gonz.Markdown.FrontMatter{
          title: "Home",
          categories: [:home, :nav_item]
        }
      }
    }
  end
end
