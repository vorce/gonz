defmodule Gonz.FrontMatterTest do
  use ExUnit.Case

  alias Gonz.Markdown.FrontMatter

  describe "parse/1" do
    test "string to elixir map" do
      created_at = "2018-08-09T17:51:32.905935Z"
      title = "Hellö there"
      categories = "[:nav_item, \"foo\"]"

      front_matter_string =
        "%{\n  title: \"#{title}\",\n  created_at: \"#{created_at}\",\n  id: 1,\n categories: #{categories}}"

      assert FrontMatter.parse(front_matter_string) == %Gonz.Markdown.FrontMatter{
               created_at: created_at,
               description: "",
               nav_item: false,
               title: title,
               categories: [:nav_item, "foo"]
             }
    end
  end
end
