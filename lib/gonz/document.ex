defmodule Gonz.Document do
  @moduledoc """
  A document represents anything that will end up in the final site;
  posts, pages, index.

  Should this be the structure passed to all templates? I think that might be
  a good idea...
  """

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
      filename: html_filename(md_file, category),
      category: category
    }
  end

  def html_filename(md_file, :posts) do
    {:ok, datetime, _} = DateTime.from_iso8601(md_file.front_matter.created_at)

    date_time_minutes =
      datetime
      |> DateTime.truncate(:second)
      |> DateTime.to_iso8601()
      |> String.split(":")
      |> Enum.take(2)
      |> Enum.join(":")

    sanitized_title = Gonz.Site.sanitize_title(md_file.front_matter.title)
    date_time_minutes <> "-" <> sanitized_title <> ".html"
  end

  def html_filename(md_file, :pages) do
    Gonz.Site.sanitize_title(md_file.front_matter.title) <> ".html"
  end

  def valid_categories(), do: [:pages, :posts, :drafts, :index]
end
