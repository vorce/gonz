defmodule Gonz.Index do
  @moduledoc """
  Index page(s)
  """

  alias Gonz.Layout
  alias Gonz.Markdown.FrontMatter

  @doc """
  Writes a html file containing posts to `index_dir`
  """
  def write_html({posts, index_page_nr}, index_dir, theme_name, opts) do
    with {:ok, index_template} <- template(theme_name),
         {:ok, layout_template} <- Gonz.Site.template(theme_name) do
      final_content =
        create_html(
          {posts, index_page_nr},
          index_template,
          layout_template,
          Keyword.merge([asset_dir: index_dir], opts)
        )

      File.write("#{index_dir}/#{file_name(index_page_nr)}", final_content)
    else
      error -> IO.puts("Unable to create html, reason: #{inspect(error)}")
    end
  end

  @doc """
  Returns a html string based on posts (and their index page), an index template and a layout template.
  """
  def create_html({posts, index_page_nr}, index_template, layout_template, opts) do
    description = index_description(posts)
    index_content = index_html({posts, index_page_nr}, index_template, opts)
    layout_opts = Keyword.merge([meta_description: description], opts)
    wrap_in_layout(index_content, layout_template, layout_opts)
  end

  defp index_html({posts, index_page_nr}, index_template, opts) do
    last_page? = Keyword.get(opts, :last_page, false)
    older = unless last_page?, do: index_link(index_page_nr + 1, "◀︎ older")
    newer = if index_page_nr > 0, do: index_link(index_page_nr - 1, "newer ▶︎")
    index_assigns = [posts: posts, older: older || "", newer: newer || ""]
    EEx.eval_string(index_template, assigns: index_assigns)
  end

  defp wrap_in_layout(html_content, layout_template, opts) do
    asset_dir = Keyword.get(opts, :asset_dir, Gonz.Build.default_output_dir())
    meta_description = Keyword.get(opts, :meta_description, "")
    navigation = Keyword.get(opts, :navigation, "")

    layout_assigns = Layout.assigns(%FrontMatter{description: meta_description}, html_content, navigation, asset_dir)
    EEx.eval_string(layout_template, assigns: layout_assigns)
  end

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/index.eex")
  end

  def index_link(0, text), do: index_link("", text)

  def index_link(nr, text) do
    "<a href=\"index#{nr}.html\">#{text}</a>"
  end

  # This decides on the meta description tag content for the index page
  # it will simply be whatever is in the first post's description.
  # Not perfect, and should probably be exposed so that you can set it to something
  # static.
  defp index_description([first_post | _]) do
    first_post.markdown.front_matter.description
  end

  defp index_description(_), do: ""

  def file_name(0), do: "index.html"
  def file_name(nr), do: "index#{nr}.html"
end
