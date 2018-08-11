defmodule Gonz.Page do
  @moduledoc false

  def create(title, opts \\ []) do
    File.write(Gonz.Site.filename_from_title("pages", title), new(title, opts))
  end

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/page.eex")
  end

  def new(title, opts) do
    nav_item = Keyword.get(opts, :nav_item?, false)
    description = Keyword.get(opts, :description, "A dull page")
    content = Keyword.get(opts, :content, "This is the #{title} page")

    """
    ---
    title: #{title}
    description: #{description}
    nav_item: #{nav_item}
    ---
    #{content}
    """
  end
end
