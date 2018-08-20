defmodule Gonz.Build do
  @moduledoc """
  Builds the html from the markdown files
  """

  def pages_build_dir(), do: output_dir() <> "/#{Gonz.Site.pages_dir()}"
  def posts_build_dir(), do: output_dir() <> "/#{Gonz.Site.posts_dir()}"

  @doc "Create index html pages, containing posts."
  def index(post_docs, theme, navigation, opts \\ []) do
    posts_per_page = Keyword.get(opts, :posts_per_page, 10)

    total_chunks = post_docs |> length() |> div(posts_per_page) |> max(1)

    post_docs
    |> Enum.sort(fn a, b ->
      a.filename >= b.filename
    end)
    |> Enum.chunk_every(posts_per_page)
    |> Enum.with_index()
    |> Enum.each(fn docs ->
      {_, page_nr} = docs
      last_page = page_nr == total_chunks - 1
      Gonz.Index.create_html(docs, output_dir(), theme, last_page: last_page, navigation: navigation)
    end)
  end

  @doc "Builds the static site html files from markdown files"
  def site(theme) do
    with _ <- File.mkdir_p(posts_build_dir()),
         _ <- File.mkdir_p(pages_build_dir()),
         {:ok, post_docs} <- Gonz.Document.load(Gonz.Site.posts_dir(), :posts),
         {:ok, page_docs} <- Gonz.Document.load(Gonz.Site.pages_dir(), :pages),
         navigation <- Gonz.Navigation.content(page_docs, theme, "../"),
         :ok <- write_documents_as_html(posts_build_dir(), post_docs, theme, navigation: navigation, category: :posts),
         :ok <- write_documents_as_html(pages_build_dir(), page_docs, theme, navigation: navigation, category: :pages) do
      index(post_docs, theme, Gonz.Navigation.content(page_docs, theme, ""))
    end
  end

  def write_documents_as_html(dir, docs, theme, opts) do
    Enum.each(docs, fn doc ->
      write_document_as_html(dir, doc, theme, opts)
    end)
  end

  def write_document_as_html(dir, %Gonz.Document{} = doc, theme, opts \\ []) do
    navigation = Keyword.get(opts, :navigation, "")
    category = Keyword.get(opts, :category, :pages)

    doc_assigns = [
      content: doc.html_content,
      front_matter: doc.markdown.front_matter,
      filename: doc.filename,
      content_dir: ""
    ]

    with {:ok, doc_content} <- category_content(theme, category, assigns: doc_assigns),
         {:ok, layout_template} <- Gonz.Site.template(theme),
         layout_assigns <- [
           content: doc_content,
           navigation: navigation,
           js: Gonz.Build.Asset.js(),
           css: Gonz.Build.Asset.css()
         ],
         final_content <- EEx.eval_string(layout_template, assigns: layout_assigns) do
      File.write(dir <> "/#{doc.filename}", final_content)
    end
  end

  def output_dir(), do: "./build"

  def category_content(theme, :pages, opts) do
    case Gonz.Page.template(theme) do
      {:ok, page_template} ->
        {:ok, EEx.eval_string(page_template, opts)}

      other ->
        other
    end
  end

  def category_content(theme, :posts, opts) do
    case Gonz.Post.template(theme) do
      {:ok, post_template} ->
        {:ok, EEx.eval_string(post_template, opts)}

      other ->
        other
    end
  end
end
