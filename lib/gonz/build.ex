defmodule Gonz.Build do
  @moduledoc """
  Builds the html from the markdown files
  """

  @doc "Create static page html files"
  def pages(:all, theme) do
    Gonz.Site.pages_dir()
    |> File.ls!()
    |> pages(theme)
  end

  def pages(pages, theme) when is_list(pages) do
    out_dir = pages_build_dir()

    with _ <- File.mkdir_p(out_dir),
         {:ok, documents} <- Gonz.Document.load(Gonz.Site.pages_dir(), :pages) do
      write_documents_as_html(out_dir, documents, theme)
    end
  end

  def pages_build_dir(), do: output_dir() <> "/#{Gonz.Site.pages_dir()}"
  def posts_build_dir(), do: output_dir() <> "/#{Gonz.Size.posts_dir()}"

  @doc "Create index html pages, containing posts."
  # TODO tidy this up a bit
  def index(theme, opts \\ []) do
    posts_per_page = Keyword.get(opts, :posts_per_page, 10)

    with {:ok, post_documents} <- Gonz.Document.load(Gonz.Site.posts_dir(), :posts),
         {:ok, page_documents} <- Gonz.Document.load(Gonz.Site.pages_dir(), :pages) do
      total_chunks = post_documents |> length() |> div(posts_per_page) |> max(1)

      navigation =
        page_documents
        |> Gonz.Navigation.docs()
        |> Gonz.Navigation.content(theme, "")

      post_documents
      |> Enum.sort(fn a, b ->
        b.filename >= a.filename
      end)
      |> Enum.chunk_every(posts_per_page)
      |> Enum.with_index()
      |> Enum.each(fn docs ->
        {_, page_nr} = docs
        last_page = page_nr == total_chunks - 1
        Gonz.Index.create_html(docs, output_dir(), theme, last_page: last_page, navigation: navigation)
      end)
    end
  end

  def write_documents_as_html(dir, docs, theme) do
    case Gonz.Navigation.docs(docs) do
      [] ->
        Enum.each(docs, fn doc -> write_document_as_html(dir, doc, theme) end)

      nav_docs ->
        Enum.each(docs, fn doc ->
          write_document_as_html(dir, doc, theme, navigation: Gonz.Navigation.content(nav_docs, theme, "../"))
        end)
    end
  end

  def write_document_as_html(dir, %Gonz.Document{} = doc, theme, opts \\ []) do
    navigation = Keyword.get(opts, :navigation, "")

    doc_assigns = [content: doc.html_content, front_matter: doc.markdown.front_matter, filename: doc.filename]

    with {:ok, page_template} <- Gonz.Page.template(theme),
         page_content <- EEx.eval_string(page_template, assigns: doc_assigns),
         {:ok, layout_template} <- Gonz.Site.template(theme),
         layout_assigns <- [
           content: page_content,
           navigation: navigation,
           js: Gonz.Build.Asset.js(),
           css: Gonz.Build.Asset.css()
         ],
         final_content <- EEx.eval_string(layout_template, assigns: layout_assigns) do
      File.write(dir <> "/#{doc.filename}", final_content)
    end
  end

  def output_dir(), do: "./build"
end
