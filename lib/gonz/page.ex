defmodule Gonz.Page do
  @moduledoc false

  def create(title, opts \\ []) do
    File.write(Gonz.Site.filename_from_title("pages", title), Gonz.Bootstrap.page(title, opts))
  end

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/page.eex")
  end
end
