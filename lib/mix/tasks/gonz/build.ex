defmodule Mix.Tasks.Gonz.Build do
  @moduledoc """
  Build the site into html
  """
  use Mix.Task

  @shortdoc "Build your gonz site"

  def run([]), do: run(["default"])

  def run([theme_name]) do
    IO.puts("Building site with theme: #{theme_name}")
    Application.ensure_all_started(:yaml_elixir)

    {microseconds, _} =
      :timer.tc(fn ->
        Gonz.Build.Asset.copy(theme_name)
        build_all_posts(theme_name)
        build_all_pages(theme_name)
        build_index_page(theme_name)
      end)

    IO.puts("Build done, took: #{microseconds * 0.000001}s. Results in #{Gonz.Build.output_dir()}")
    IO.puts("Open build/index.html in a browser to see your site")

    :ok
  end

  def build_all_pages(theme_name) do
    IO.puts("Building pages...")
    Gonz.Build.pages(:all, theme_name)
  end

  def build_all_posts(theme_name) do
    IO.puts("Building posts...")
    # Gonz.Build.posts(:all)
  end

  def build_index_page(theme_name) do
    IO.puts("Building index page...")
    Gonz.Build.index(theme_name)
  end
end
