defmodule Gonz.Template do
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

  def post_template do
    """
    <div id="post">
      <h2>
        <a href="<%= @filename %>"><%= @frontmatter.title %></a>
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
    created: #{Gonz.now_iso8601()}
    ---
    Welcome to your brand new post.
    """
  end

  def layout(name) do
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

  def index do
    """
    <div class="index">
      <%= Enum.map @content, fn(post) ->
        \"\"\"
        #\{post.content}
        <hr />
        \"\"\"
      end %>
      <%= @prev %>
      <%= @next %>
    </div>
    """
  end

  def page_template do
    """
    <div id="page">
      <%= @frontmatter.title %>
      <hr />
      <%= @content %>
    </div>
    """
  end

  def page(title) do
    """
    ---
    title: #{title}
    description: A new page
    ---
    This is the #{title} page.
    """
  end
end
