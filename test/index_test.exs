defmodule Gonz.IndexTest do
  use ExUnit.Case

  alias Gonz.Index

  describe "create_html/4" do
    test "includes meta description tag set to first post description" do
      expected_description = "back biggie"
      post_docs = [test_post("post1", expected_description), test_post("post2", "description2")]

      layout_template = """
        <!DOCTYPE html>
        <html>
          <head>
            <title>Yo</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
            <meta name="generator" content="Gonz" />
            <meta name="Description" content="<%= @meta.description %>">
          </head>
        </html>
      """

      assert Index.create_html({post_docs, 0}, "", layout_template, []) =~
               "<meta name=\"Description\" content=\"#{expected_description}\">"
    end
  end

  defp test_post(title, description) do
    %Gonz.Document{
      type: :post,
      markdown: %Gonz.Markdown{
        front_matter: %Gonz.Markdown.FrontMatter{
          title: title,
          description: description
        }
      }
    }
  end
end
