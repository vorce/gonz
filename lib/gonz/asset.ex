defmodule Gonz.Asset do
  def copy(theme) do
    File.mkdir_p("./build/assets")
    File.cp_r("./themes/#{theme}/assets", "./build/assets")
  end

  def css_files() do
    File.ls!("./build/assets/css")
    |> Enum.sort()
    |> Enum.map(&"assets/css/#{&1}")
    |> Enum.filter(&(!File.dir?("./build/#{&1}")))
  end

  def js_files() do
    File.ls!("./build/assets/js")
    |> Enum.sort()
    |> Enum.map(&"assets/js/#{&1}")
    |> Enum.filter(&(!File.dir?("./build/#{&1}")))
  end

  def css(prefix \\ "../") do
    css_files()
    |> Enum.map(&"<link rel=\"stylesheet\" href=\"#{prefix}#{&1}\" />")
    |> Enum.join("\n")
  end

  def js(prefix \\ "../") do
    js_files()
    |> Enum.map(&"<script type=\"text/javascript\" src=\"#{prefix}#{&1}\"></script>")
    |> Enum.join("\n")
  end
end
