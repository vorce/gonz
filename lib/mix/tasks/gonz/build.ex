defmodule Mix.Tasks.Gonz.Build do
  @moduledoc """
  Build the site into html
  """
  use Mix.Task

  @shortdoc "Build your gonz site"

  def run(_args) do
    {microseconds, _} = :timer.tc(fn ->
      build_all_posts()
      build_all_pages()
      build_index_page()
    end)
    IO.puts("Build done, took: #{microseconds * 0.000001}s. Results in #{Gonz.Build.output_dir()}")
    :ok
  end

  def build_all_pages() do
    IO.puts("Building pages...")
    Gonz.Build.pages(:all)
  end

  def build_all_posts() do
    IO.puts("Building posts...")
    # Gonz.Build.posts(:all)
  end

  def build_index_page() do
    IO.puts("Building index page...")
  end
end
