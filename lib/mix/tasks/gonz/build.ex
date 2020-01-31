defmodule Mix.Tasks.Gonz.Build do
  @moduledoc """
  Build the site into html
  """
  use Mix.Task

  @shortdoc "Build your gonz site"

  @default_theme_name "default"
  @default_posts_per_page "10"

  def run([]), do: run([@default_theme_name, Gonz.Build.default_output_dir(), @default_posts_per_page])

  def run([theme_name]), do: run([theme_name, Gonz.Build.default_output_dir(), @default_posts_per_page])

  def run([theme_name, output]), do: run([theme_name, output, @default_posts_per_page])

  def run([theme_name, output, posts_per_page_input]) do
    posts_per_page = String.to_integer(posts_per_page_input)
    settings = [theme_name: theme_name, output_dir: output, posts_per_page: posts_per_page]

    IO.puts("Building site with settings: #{inspect(settings)}...")

    Application.ensure_all_started(:yaml_elixir)

    {microseconds, _} =
      :timer.tc(fn ->
        Gonz.Build.Asset.copy_theme(theme_name, output)
        Gonz.Build.Asset.copy_site(output)
        Gonz.Build.site(theme_name, output, posts_per_page: posts_per_page)
      end)

    IO.puts("Build done, took: #{microseconds * 0.000001}s")
    IO.puts("Baked files in \"#{output}\" can now be served by: mix gonz.serve #{output}")

    :ok
  end

  def run(_) do
    IO.puts(:stderr, "Expected zero or 3 arguments (theme name, output directory, posts_per_page) to this task")
  end
end
