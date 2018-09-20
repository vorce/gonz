defmodule Gonz.Build do
  @moduledoc """
  Builds the html from the markdown files
  """

  def pages_build_dir(output), do: output
  def posts_build_dir(output), do: output <> "/#{Gonz.Site.posts_dir()}"

  @doc "Create index html pages, containing posts."
  def index(post_docs, theme, navigation, opts \\ []) do
    posts_per_page = Keyword.get(opts, :posts_per_page, 10)
    output_dir = Keyword.get(opts, :output, default_output_dir())

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
      Gonz.Index.create_html(docs, output_dir, theme, last_page: last_page, navigation: navigation)
    end)
  end

  @doc "Builds the static site html files from markdown files"
  def site(theme, output) do
    posts_output = posts_build_dir(output)
    pages_output = pages_build_dir(output)

    with _ <- File.mkdir_p(posts_output),
         _ <- File.mkdir_p(pages_output),
         {:ok, post_docs} <- Gonz.Document.load(Gonz.Site.posts_dir(), :posts),
         {:ok, page_docs} <- Gonz.Document.load(Gonz.Site.pages_dir(), :pages),
         post_navigation <- Gonz.Navigation.content(page_docs, theme),
         page_navigation <- Gonz.Navigation.content(page_docs, theme),
         :ok <- write_documents_as_html(posts_output, post_docs, theme, navigation: post_navigation, category: :posts),
         :ok <- write_documents_as_html(pages_output, page_docs, theme, navigation: page_navigation, category: :pages) do
      index(post_docs, theme, page_navigation, output: output)
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

    with doc_assigns <- Gonz.Document.to_assigns(doc),
         {:ok, doc_content} <- category_content(theme, category, assigns: doc_assigns),
         {:ok, layout_template} <- Gonz.Site.template(theme),
         # This is really awkward..
         asset_dir <- dir |> Path.split() |> Enum.take(2) |> Path.join(),
         layout_assigns <- [
           content: doc_content,
           navigation: navigation,
           js: Gonz.Build.Asset.js(asset_dir),
           css: Gonz.Build.Asset.css(asset_dir)
         ],
         final_content <- EEx.eval_string(layout_template, assigns: layout_assigns) do
      File.write(dir <> "/#{doc.filename}", final_content)
    end
  end

  def default_output_dir(), do: "./build"

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
