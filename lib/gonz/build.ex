defmodule Gonz.Build do
  @moduledoc """
  Builds the html from the markdown files
  """

  def pages(:all, theme) do
    Gonz.Site.pages_dir()
    |> File.ls!()
    |> pages(theme)
  end

  def pages(pages, theme) when is_list(pages) do
    out_dir = pages_build_dir()

    with _ <- File.mkdir_p(out_dir),
         {:ok, markdowns} <- Gonz.Markdown.parse(pages, Gonz.Site.pages_dir()),
         {:ok, documents} <- Gonz.Document.from_markdown_files(markdowns, :pages) do
      write_documents_as_html(out_dir, documents, theme)
    end
  end

  def pages_build_dir(), do: output_dir() <> "/#{Gonz.Site.pages_dir()}"
  def posts_build_dir(), do: output_dir() <> "/{Gonz.Size.posts.dir()}"

  def index(opts \\ []) do
    posts_per_page = Keyword.get(opts, :posts_per_page, 10)

    built_posts_dir = posts_build_dir()
    built_pages_dir = pages_build_dir()

    # with {:ok, pages} <- File.ls(built_pages_dir) do
    #   pages
    #   |> Enum.sort()
    #   |> Enum.reverse()
    #   |> Enum.with_index()
    #   |> Enum.chunk_every(posts_per_page)
    #   |> IO.inspect(label: "index posts")
    # end
    with {:ok, pages} <- File.ls(built_pages_dir) do
      pages
      |> Enum.sort()
      |> Enum.with_index()
      |> IO.inspect(label: "pages")
    end
  end

  def write_documents_as_html(dir, docs, theme) do
    Enum.each(docs, fn doc -> write_document_as_html(dir, doc, theme) end)
  end

  def write_document_as_html(dir, %Gonz.Document{} = doc, theme) do
    doc_assigns = [content: doc.html_content, front_matter: doc.markdown.front_matter, filename: doc.file_name]

    with {:ok, page_template} <- Gonz.Page.template(theme),
         page_content <- EEx.eval_string(page_template, assigns: doc_assigns),
         {:ok, layout_template} <- Gonz.Site.template(theme),
         layout_assigns <- [content: page_content, js: Gonz.Asset.js(), css: Gonz.Asset.css()],
         final_content <- EEx.eval_string(layout_template, assigns: layout_assigns) do
      File.write(dir <> "/#{doc.file_name}", final_content)
    end
  end

  def output_dir(), do: "./build"
end
