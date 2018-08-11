defmodule Gonz.Post do
  @moduledoc """
  Post stuff
  """

  def create(title) do
    File.write(Gonz.Site.filename_from_title("posts", title), Gonz.Bootstrap.post(title))
  end

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/post.eex")
  end
end
