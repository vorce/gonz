defmodule Mix.Tasks.Gonz.Build do
  @moduledoc """
  Build the site into html
  """
  use Mix.Task

  @shortdoc "Build your gonz site"

  def run([]), do: run(["default", "all"])

  def run([theme_name, "all"]) do
    IO.puts("Building site with theme: #{theme_name}")
    Application.ensure_all_started(:yaml_elixir)

    {microseconds, _} =
      :timer.tc(fn ->
        Gonz.Build.Asset.copy(theme_name)
        Gonz.Build.site(theme_name)
      end)

    IO.puts("Build done, took: #{microseconds * 0.000001}s. Results in #{Gonz.Build.output_dir()}")
    IO.puts("Open build/index.html in a browser to see your site")

    :ok
  end
end
