defmodule Gonz.Build.Asset do
  @moduledoc """
  Static assets for the theme
  """

  def copy_theme(theme, output) do
    File.mkdir_p("./#{output}/assets")
    File.cp_r("./themes/#{theme}/assets", "./#{output}/assets")
  end

  def copy_site(output) do
    File.mkdir_p("./#{output}/assets")
    File.cp_r("./assets", "./#{output}/assets")
  end

  def css_files(output) do
    path = "./#{output}/assets/css"

    case File.ls(path) do
      {:ok, files} ->
        files
        |> Enum.filter(fn file -> String.ends_with?(file, [".css"]) end)
        |> Enum.sort()
        |> Enum.map(&"/assets/css/#{&1}")
        |> Enum.filter(&(!File.dir?("./#{output}/#{&1}")))

      error ->
        IO.puts("Unable to list files in #{path}: #{inspect(error)} - skipping CSS assets")
        []
    end
  end

  def js_files(output) do
    path = "./#{output}/assets/js"

    case File.ls(path) do
      {:ok, files} ->
        files
        |> Enum.filter(fn file -> String.ends_with?(file, [".js"]) end)
        |> Enum.sort()
        |> Enum.map(&"/assets/js/#{&1}")
        |> Enum.filter(&(!File.dir?("./#{output}/#{&1}")))

      error ->
        IO.puts("Unable to list files in #{path}: #{inspect(error)} - skipping JS assets")
        []
    end
  end

  def css(output) do
    css_files(output)
    |> Enum.map(&"<link rel=\"stylesheet\" href=\"#{&1}\" />")
    |> Enum.join("\n")
  end

  def js(output) do
    js_files(output)
    |> Enum.map(&"<script type=\"text/javascript\" src=\"#{&1}\"></script>")
    |> Enum.join("\n")
  end
end
