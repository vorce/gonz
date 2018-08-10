defmodule Gonz.Bootstrap do
  @moduledoc """
  Project template
  """

  def config(name) do
    """
    ---
    name: #{name} - a brand new static site
    url: http://my.blog.url
    description: This is my site about things
    language: en-us
    posts_per_page: 10
    sort_posts: ascending
    theme: default
    """
  end

  def post_template() do
    """
    <div id="post">
      <h2>
        <a href="<%= @filename %>"><%= @front_matter.title %></a>
      </h2>
      <%= @content %>
    </div>
    """
  end

  def post(title) do
    """
    ---
    title: #{title}
    description: A new post
    created_at: #{Gonz.now_iso8601()}
    ---
    Welcome to your brand new post.
    """
  end

  def layout_template(name) do
    """
    <!DOCTYPE html>
    <html>
      <head>
        <title>#{name}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <%= @css %>
        <%= @js %>
      </head>
      <body>
        <div class="container">
          <h1>#{name}</h1>

          <%= @navigation %>

          <%= @content %>
        </div>
      </body>
    </html>
    """
  end

  def base_css() do
    """
    body {
      margin: 0;
      padding: 0;
    }
    .container {
      width: 980px;
      margin: 0 auto;
    }
    """
  end

  def index_template() do
    """
    <div class="index">
      <%= Enum.map @posts, fn post ->
        \"\"\"
        <h2>#\{post.markdown.front_matter.title}</h2>
        #\{post.html_content}
        <hr />
        \"\"\"
      end %>
      <%= @older %>
      <%= @newer %>
    </div>
    """
  end

  def page_template() do
    """
    <div id="page">
      <%= @front_matter.title %>
      <hr />
      <%= @content %>
    </div>
    """
  end

  def page(title, opts) do
    nav_item = Keyword.get(opts, :nav_item?, false)
    description = Keyword.get(opts, :description, "A dull page")
    content = Keyword.get(opts, :content, "This is the #{title} page")

    """
    ---
    title: #{title}
    description: #{description}
    nav_item: #{nav_item}
    ---
    #{content}
    """
  end

  def navigation_template() do
    """
    <div id="nav">
      <ul>
      <%= Enum.map(@items, fn item ->
        url = if item.category == :index do
          "#\{@href_prefix}#\{item.filename}"
        else
          "#\{@href_prefix}#\{item.category}/#\{item.filename}"
        end
        \"\"\"
        <li><a href="#\{url}">#\{item.front_matter.title}</a></li>
        \"\"\"
      end) %>
      </ul>
    </div>
    """
  end
end
