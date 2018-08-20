defmodule Gonz.Build.Asset do
  @moduledoc """
  Static assets for the theme
  """

  def copy(theme, output) do
    File.mkdir_p("./#{output}/assets")
    File.cp_r("./themes/#{theme}/assets", "./#{output}/assets")
  end

  def css_files(output) do
    File.ls!("./#{output}/assets/css")
    |> Enum.filter(fn file -> String.ends_with?(file, [".css"]) end)
    |> Enum.sort()
    |> Enum.map(&"assets/css/#{&1}")
    |> Enum.filter(&(!File.dir?("./#{output}/#{&1}")))
  end

  def js_files(output) do
    File.ls!("./#{output}/assets/js")
    |> Enum.filter(fn file -> String.ends_with?(file, [".js"]) end)
    |> Enum.sort()
    |> Enum.map(&"assets/js/#{&1}")
    |> Enum.filter(&(!File.dir?("./#{output}/#{&1}")))
  end

  def css(output, prefix \\ "../") do
    css_files(output)
    |> Enum.map(&"<link rel=\"stylesheet\" href=\"#{prefix}#{&1}\" />")
    |> Enum.join("\n")
  end

  def js(output, prefix \\ "../") do
    js_files(output)
    |> Enum.map(&"<script type=\"text/javascript\" src=\"#{prefix}#{&1}\"></script>")
    |> Enum.join("\n")
  end
end
