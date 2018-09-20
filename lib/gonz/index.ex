defmodule Gonz.Index do
  @moduledoc """
  Index page(s)
  """

  def create_html({posts, index_page_nr}, index_dir, theme, opts) do
    navigation = Keyword.get(opts, :navigation, "")
    last_page? = Keyword.get(opts, :last_page, false)
    older = unless last_page?, do: index_link(index_page_nr + 1, "◀︎ older")
    newer = if index_page_nr > 0, do: index_link(index_page_nr - 1, "newer ▶︎")

    index_assigns = [posts: posts, older: older || "", newer: newer || ""]

    with {:ok, index_template} <- template(theme),
         index_content <- EEx.eval_string(index_template, assigns: index_assigns),
         {:ok, layout_template} <- Gonz.Site.template(theme),
         layout_assigns <- [
           content: index_content,
           navigation: navigation,
           js: Gonz.Build.Asset.js(index_dir),
           css: Gonz.Build.Asset.css(index_dir)
         ],
         final_content <- EEx.eval_string(layout_template, assigns: layout_assigns) do
      File.write("#{index_dir}/#{file_name(index_page_nr)}", final_content)
    end
  end

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/index.eex")
  end

  def index_link(0, text), do: index_link("", text)

  def index_link(nr, text) do
    "<a href=\"index#{nr}.html\">#{text}</a>"
  end

  def file_name(0), do: "index.html"
  def file_name(nr), do: "index#{nr}.html"
end
