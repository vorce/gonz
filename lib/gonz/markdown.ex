defmodule Gonz.Markdown do
  @moduledoc false

  defstruct content: "",
            front_matter: %Gonz.Markdown.FrontMatter{},
            filename: ""

  def parse(files, dir) when is_list(files) do
    result = Enum.map(files, fn file -> parse(file, dir) end)

    if Enum.all?(result, fn result -> match?(%__MODULE__{}, result) end) do
      {:ok, result}
    else
      {:error, result}
    end
  end

  def parse(file, dir) when is_binary(file) do
    with {:ok, contents} <- File.read(dir <> "/#{file}") do
      %__MODULE__{parse(contents) | filename: file}
    end
  end

  def parse(content_string) when is_binary(content_string) do
    with {:ok, content: content, front_matter: front} <- markdown_parts(content_string),
         %Gonz.Markdown.FrontMatter{} = fm <- Gonz.Markdown.FrontMatter.parse(front) do
      %__MODULE__{
        content: content,
        front_matter: fm
      }
    end
  end

  def markdown_parts(contents) do
    [front_matter | content] = String.split(contents, "\n---\n")
    {:ok, content: Enum.join(content, "\n"), front_matter: String.replace(front_matter, "---\n", "")}
  end
end
