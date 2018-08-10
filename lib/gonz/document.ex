defmodule Gonz.Document do
  @moduledoc false

  defstruct markdown: %Gonz.Markdown{},
            html_content: "",
            filename: "",
            category: :unknown

  def load(dir, category) do
    with {:ok, files} <- File.ls(dir),
         {:ok, markdowns} <- Gonz.Markdown.parse(files, dir) do
      from_markdown_files(markdowns, category)
    end
  end

  def from_markdown_files(md_files, category) when is_list(md_files) do
    result = Enum.map(md_files, fn md_file -> from_markdown_file(md_file, category) end)
    {:ok, result}
  end

  def from_markdown_file(%Gonz.Markdown{} = md_file, category) do
    %__MODULE__{
      markdown: md_file,
      html_content: Earmark.as_html!(md_file.content),
      filename: html_filename(md_file),
      category: category
    }
  end

  def html_filename(md_file) do
    base =
      md_file.filename
      |> String.split(".")
      |> Enum.reverse()
      |> Enum.drop(1)
      |> Enum.reverse()
      |> Enum.join(".")

    base <> ".html"
  end

  def valid_categories(), do: [:pages, :posts, :drafts, :index]
end
