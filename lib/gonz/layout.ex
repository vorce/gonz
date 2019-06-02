defmodule Gonz.Layout do
  alias Gonz.Markdown.FrontMatter

  def assigns(%FrontMatter{} = front_matter, content, navigation, asset_dir) do
    [
      meta: front_matter,
      content: content,
      navigation: navigation,
      js: Gonz.Build.Asset.js(asset_dir),
      css: Gonz.Build.Asset.css(asset_dir)
    ]
  end
end
