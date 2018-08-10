defmodule Gonz.Site do
  @moduledoc """
  New gonz site
  """
  require Logger

  def new(name) do
    with :ok <- create_default_theme(name),
         :ok <- create_content_dirs(),
         :ok <- Gonz.Page.create("About", nav_item?: true),
         :ok <- Gonz.Page.create("Somepage"),
         :ok <- Gonz.Post.create("Hello #{name}"),
         :ok <- File.write("./site.yml", Gonz.Bootstrap.config(name)) do
      update_gitignore()
    end
  end

  def create_default_theme(project_name) do
    theme_name = "default"

    with :ok <- create_assets_dirs(theme_name) do
      create_layout(theme_name, project_name)
    end
  end

  defp create_assets_dirs(theme_name) do
    theme_dir = themes_dir()

    dirs = [
      "#{theme_dir}/#{theme_name}/assets",
      "#{theme_dir}/#{theme_name}/assets/css",
      "#{theme_dir}/#{theme_name}/assets/js",
      "#{theme_dir}/#{theme_name}/assets/img"
    ]

    IO.puts("Creating asset directories: #{inspect(dirs)}")

    all_dirs_created? =
      dirs
      |> Enum.map(&File.mkdir_p/1)
      |> Enum.all?(fn return_val -> return_val == :ok end)

    if all_dirs_created? do
      File.write("#{theme_dir}/#{theme_name}/assets/css/base.css", Gonz.Bootstrap.base_css())
    else
      {:error, "Unable to create asset directories for theme: #{theme_name}"}
    end
  end

  defp create_layout(theme_name, project_name) do
    theme_dir = themes_dir()
    layout_dir = "#{theme_dir}/#{theme_name}/layout"

    with _ <- IO.puts("Creating layout directory and templates: #{layout_dir}"),
         :ok <- File.mkdir_p("#{layout_dir}"),
         :ok <- File.write("#{layout_dir}/post.eex", Gonz.Bootstrap.post_template()),
         :ok <- File.write("#{layout_dir}/layout.eex", Gonz.Bootstrap.layout_template(project_name)),
         :ok <- File.write("#{layout_dir}/navigation.eex", Gonz.Bootstrap.navigation_template()),
         :ok <- File.write("#{layout_dir}/index.eex", Gonz.Bootstrap.index_template()) do
      File.write("#{layout_dir}/page.eex", Gonz.Bootstrap.page_template())
    end
  end

  defp create_content_dirs() do
    content_dirs = [posts_dir(), drafts_dir(), pages_dir()]
    IO.puts("Creating content directories: #{inspect(content_dirs)}")

    case Enum.map(content_dirs, &File.mkdir/1) do
      [:ok, :ok, :ok] ->
        :ok

      not_ok ->
        errors = Enum.reject(not_ok, fn return_val -> return_val == :ok end)
        {:error, errors}
    end
  end

  defp update_gitignore() do
    File.open("./.gitignore", [:append], fn file ->
      IO.binwrite(file, "\n/build\n")
    end)
  end

  def content_directories() do
    [posts_dir(), drafts_dir(), pages_dir()]
  end

  def posts_dir(), do: "./posts"
  def drafts_dir(), do: "./drafts"
  def pages_dir(), do: "./pages"
  def themes_dir(), do: "./themes"

  def filename_from_title("pages", title), do: "#{pages_dir()}/#{sanitize_title(title)}.md"

  def filename_from_title("posts", title) do
    date_string =
      DateTime.utc_now()
      |> DateTime.to_iso8601()

    # |> DateTime.to_date()
    # |> Date.to_string()

    safe_title = sanitize_title(title)
    "#{posts_dir()}/#{date_string}-#{safe_title}.md"
  end

  def sanitize_title(title) do
    title
    |> String.downcase()
    |> String.replace(" ", "-")
  end

  def template(theme_name) do
    File.read("#{Gonz.Site.themes_dir()}/#{theme_name}/layout/layout.eex")
  end
end
