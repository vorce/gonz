defmodule Gonz.Markdown do
  @moduledoc false

  defstruct content: "",
            front_matter: "",
            file_name: ""

  def parse(files, dir) when is_list(files) do
    result = Enum.map(files, fn file -> parse(file, dir) end)

    if Enum.all?(result, fn result -> match?(%__MODULE__{}, result) end) do
      {:ok, result}
    else
      {:error, result}
    end
  end

  def parse(file, dir) when is_binary(file) do
    with {:ok, contents} <- File.read(dir <> "/#{file}"),
         {:ok, content: content, front_matter: front} <- markdown_parts(contents),
         %Gonz.Markdown.FrontMatter{} = fm <- Gonz.Markdown.FrontMatter.parse(front) do
      %__MODULE__{
        content: content,
        front_matter: fm,
        file_name: file
      }
    end
  end

  def markdown_parts(contents) do
    [front_matter | content] = String.split(contents, "\n---\n")
    {:ok, content: Enum.join(content, "\n"), front_matter: front_matter}
  end
end
