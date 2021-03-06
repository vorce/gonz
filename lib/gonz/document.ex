defmodule Gonz.Document do
  @moduledoc """
  A document represents anything that will end up in the final site;
  posts, pages, index.
  """

  defstruct markdown: %Gonz.Markdown{},
            html_content: "",
            filename: "",
            type: :unknown

  def load(dir, type) do
    with {:ok, files} <- File.ls(dir),
         {:ok, markdowns} <- Gonz.Markdown.parse(files, dir) do
      from_markdown_files(markdowns, type)
    end
  end

  def from_markdown_files(md_files, type) when is_list(md_files) do
    result = Enum.map(md_files, fn md_file -> from_markdown_file(md_file, type) end)
    {:ok, result}
  end

  def from_markdown_file(%Gonz.Markdown{} = md_file, type) do
    %__MODULE__{
      markdown: md_file,
      html_content: Earmark.as_html!(md_file.content),
      filename: html_filename(md_file, type),
      type: type
    }
  end

  def html_filename(md_file, :posts) do
    {:ok, datetime, _} = DateTime.from_iso8601(md_file.front_matter.created_at)

    date_string =
      datetime
      |> DateTime.truncate(:second)
      |> DateTime.to_date()
      |> Date.to_iso8601()

    sanitized_title = Gonz.Site.sanitize_title(md_file.front_matter.title)
    date_string <> "-" <> sanitized_title <> ".html"
  end

  def html_filename(md_file, :pages) do
    Gonz.Site.sanitize_title(md_file.front_matter.title) <> ".html"
  end

  def valid_types(), do: [:pages, :posts, :drafts, :index]

  @doc "This determines the available variables in the pages and post theme templates"
  def to_assigns(%__MODULE__{} = doc, content_dir \\ "") do
    [
      content: doc.html_content,
      front_matter: doc.markdown.front_matter,
      filename: doc.filename,
      content_dir: content_dir
    ]
  end
end
