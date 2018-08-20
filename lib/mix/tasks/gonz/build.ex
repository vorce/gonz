defmodule Mix.Tasks.Gonz.Build do
  @moduledoc """
  Build the site into html
  """
  use Mix.Task

  @shortdoc "Build your gonz site"

  def run([]), do: run(["default", Gonz.Build.default_output_dir()])

  def run([theme_name, output]) do
    IO.puts("Building site with theme: #{theme_name} into output directory: #{output}")
    Application.ensure_all_started(:yaml_elixir)

    {microseconds, _} =
      :timer.tc(fn ->
        Gonz.Build.Asset.copy(theme_name, output)
        Gonz.Build.site(theme_name, output)
      end)

    IO.puts("Build done, took: #{microseconds * 0.000001}s")
    IO.puts("Open #{output}/index.html in a browser to see your site")

    :ok
  end

  def run(_) do
    IO.puts(:stderr, "Expected no arguments or two (theme name, output directory) to this task")
  end
end
