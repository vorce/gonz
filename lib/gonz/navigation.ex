defmodule Gonz.Navigation do
  @moduledoc """
  """

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/navigation.eex")
  end

  def docs(docs, opts \\ []) do
    include_index = Keyword.get(opts, :include_index, true)
    extra_docs = if include_index, do: [index_doc()], else: []

    (extra_docs ++ docs)
    |> Enum.filter(fn doc -> doc.markdown.front_matter.nav_item == true end)
    |> Enum.sort(fn a, b ->
      a.filename >= b.filename
    end)
    # TODO: Feel like not converting this. Need to also change the template in that case.
    |> Enum.map(fn doc ->
      %{
        filename: doc.filename,
        front_matter: doc.markdown.front_matter,
        category: doc.category
      }
    end)
  end

  def content([], _, _), do: ""

  def content(nav_docs, theme, href_prefix) do
    with {:ok, nav_template} <- template(theme),
         assigns <- [items: nav_docs, href_prefix: href_prefix] do
      EEx.eval_string(nav_template, assigns: assigns)
    end
  end

  def index_doc() do
    %Gonz.Document{
      filename: "index.html",
      category: :index,
      markdown: %Gonz.Markdown{
        front_matter: %Gonz.Markdown.FrontMatter{
          title: "Home",
          nav_item: true
        }
      }
    }
  end
end
