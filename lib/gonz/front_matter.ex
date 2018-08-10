defmodule Gonz.Markdown.FrontMatter do
  defstruct title: "",
            description: "",
            created_at: nil,
            nav_item: false

  def parse(front_matter) when is_binary(front_matter) do
    with {:ok, map} <- YamlElixir.read_from_string(front_matter) do
      %__MODULE__{
        title: Map.get(map, "title"),
        description: Map.get(map, "description"),
        created_at: Map.get(map, "created_at"),
        nav_item: Map.get(map, "nav_item", false)
      }
    end
  end
end
