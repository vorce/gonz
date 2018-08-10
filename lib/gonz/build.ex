defmodule Gonz.Build do
  @moduledoc """
  Builds the html from the markdown files
  """

  def pages(:all) do
    Gonz.Site.pages_dir()
    |> File.ls!()
    |> pages()
  end
  def pages(pages) when is_list(pages) do
    with _ <- File.mkdir(output_dir()),
         {:ok, markdowns} <- Gonz.Markdown.parse(pages, Gonz.Site.pages_dir()),
         {:ok, documents} <- Gonz.Document.from_markdown_files(markdowns) do
      write_documents_as_html(output_dir() <> "/#{Gonz.Site.pages_dir()}", documents)
    end
  end

  def index() do
    # TODO
  end

  def write_documents_as_html(dir, docs) do
    Enum.each(docs, fn doc -> write_document_as_html(dir, doc) end)
  end

  def write_document_as_html(dir, %Gonz.Document{} = doc) do
    File.write(dir <> "/#{doc.file_name}", doc.html_content)
  end

  def output_dir(), do: "./build"
end
