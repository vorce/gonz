defmodule Gonz.PostTest do
  use ExUnit.Case

  alias Gonz.Post

  describe "new/2" do
    test "is parsable" do
      title = "Test post 123"
      new_post = Post.new(title)

      result = Gonz.Markdown.parse(new_post)

      assert %Gonz.Markdown{
               filename: "",
               content: "This is a post!\n",
               front_matter: %Gonz.Markdown.FrontMatter{
                 title: ^title
               }
             } = result

      assert {:ok, _, _} = DateTime.from_iso8601(result.front_matter.created_at)
    end
  end
end
