defmodule Gonz.Markdown.FrontMatter do
  @moduledoc """
  This is metadata in the posts/pages markdown, before the actual content.
  """

  defstruct title: "",
            description: "",
            created_at: nil,
            nav_item: false

  def parse(front_matter) when is_binary(front_matter) do
    with {map, _} <- Code.eval_string(front_matter) do
      # with {:ok, map} <- YamlElixir.read_from_string(front_matter) do
      %__MODULE__{
        title: map.title,
        description: Map.get(map, :description, ""),
        created_at: map.created_at,
        nav_item: Map.get(map, :nav_item, false)
      }
    end
  end
end
