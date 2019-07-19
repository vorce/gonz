defmodule Gonz.Page do
  @moduledoc false

  def create(title, opts \\ []) do
    File.write(Gonz.Site.filename_from_title("pages", title), new(title, opts))
  end

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/page.eex")
  end

  def new(title, opts) do
    description = Keyword.get(opts, :description, "A dull page")
    content = Keyword.get(opts, :content, "This is the #{title} page")
    created_at = Keyword.get(opts, :created_at, Gonz.now_iso8601())
    categories = Keyword.get(opts, :categories, [])

    """
    ---
    %{
      title: "#{title}",
      description: "#{description}",
      categories: #{inspect(categories)},
      created_at: "#{created_at}"
    }
    ---
    #{content}
    """
  end
end
