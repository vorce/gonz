defmodule Gonz.PageTest do
  use ExUnit.Case

  alias Gonz.Page

  describe "new/2" do
    test "is parsable" do
      title = "Böring"
      new_page = Page.new(title, [])

      assert %Gonz.Markdown{
               content: "This is the Böring page\n",
               front_matter: %Gonz.Markdown.FrontMatter{
                 categories: [],
                 title: ^title
               }
             } = Gonz.Markdown.parse(new_page)
    end
  end
end
