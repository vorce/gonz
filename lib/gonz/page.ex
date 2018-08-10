defmodule Gonz.Page do
  def create(title) do
    File.write(Gonz.Site.filename_from_title("pages", title), Gonz.Template.page(title))
  end

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/page.eex")
  end
end
