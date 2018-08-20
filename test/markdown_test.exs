defmodule Gonz.MarkdownTest do
  use ExUnit.Case

  alias Gonz.Markdown

  describe "markdown_parts/1" do
    test "returns front matter and markdown content from file contents" do
      file_contents = """
      ---
      %{
        hello: "bar",
        waddap: "2018-08-09T17:51:32.905935Z",
        id: 1
      }
      ---
      Sup
      """

      assert Markdown.markdown_parts(file_contents) ==
               {:ok,
                [
                  content: "Sup\n",
                  front_matter: "%{\n  hello: \"bar\",\n  waddap: \"2018-08-09T17:51:32.905935Z\",\n  id: 1\n}"
                ]}
    end
  end
end
