defmodule Gonz.Markdown.FrontMatter do
  @moduledoc """
  This is metadata in the posts/pages markdown, before the actual content.

  - title: The title of the page or post
  - description: Description
  - created_at: ISO8601 date time of when the page/post was created
  - categories: A list of categories the page/post belongs to, these can be anything and themes can do whatever they like with the information.
  """

  defstruct title: "",
            description: "",
            created_at: nil,
            categories: [],
            nav_item: false

  def parse(front_matter) when is_binary(front_matter) do
    with {map, _} <- Code.eval_string(front_matter) do
      %__MODULE__{
        title: map.title,
        description: Map.get(map, :description, ""),
        created_at: map.created_at,
        categories: Map.get(map, :categories, []),
        nav_item: Map.get(map, :nav_item, false)
      }
    end
  end
end
