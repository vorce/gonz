defmodule Gonz.Post do
  @moduledoc """
  Post stuff
  """

  def create(title, opts \\ []) do
    File.write(Gonz.Site.filename_from_title("posts", title), new(title, opts))
  end

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/post.eex")
  end

  def new(title, opts \\ []) do
    description = Keyword.get(opts, :description, "A new post")
    created_at = Keyword.get(opts, :created_at, Gonz.now_iso8601())
    content = Keyword.get(opts, :content, "This is a post!")

    """
    ---
    %{
      title: "#{title}",
      description: "#{description}",
      created_at: "#{created_at}"
    }
    ---
    #{content}
    """
  end
end
