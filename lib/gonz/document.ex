defmodule Gonz.Document do
  @moduledoc false

  defstruct markdown: %Gonz.Markdown{},
            html_content: "",
            file_name: ""

  def from_markdown_files(md_files) when is_list(md_files) do
    result = Enum.map(md_files, &from_markdown_file/1)
    {:ok, result}
  end

  def from_markdown_file(%Gonz.Markdown{} = md_file) do
    %__MODULE__{
      markdown: md_file,
      html_content: Earmark.as_html!(md_file.content),
      file_name: html_filename(md_file),
    }
  end

  def html_filename(md_file) do
    [base, suffix] = String.split(md_file.file_name, ".")
    base <> ".html"
  end
end
