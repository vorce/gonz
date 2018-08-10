defmodule Gonz.Document do
  @moduledoc false

  defstruct markdown: %Gonz.Markdown{},
            html_content: "",
            file_name: "",
            category: :unknown

  def from_markdown_files(md_files, category) when is_list(md_files) do
    result = Enum.map(md_files, fn md_file -> from_markdown_file(md_file, category) end)
    {:ok, result}
  end

  def from_markdown_file(%Gonz.Markdown{} = md_file, category) do
    %__MODULE__{
      markdown: md_file,
      html_content: Earmark.as_html!(md_file.content),
      file_name: html_filename(md_file),
      category: category
    }
  end

  def html_filename(md_file) do
    base =
      md_file.file_name
      |> String.split(".")
      |> Enum.reverse()
      |> Enum.drop(1)
      |> Enum.reverse()
      |> Enum.join()

    base <> ".html"
  end
end
