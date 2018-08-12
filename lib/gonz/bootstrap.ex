defmodule Gonz.Bootstrap do
  @moduledoc """
  Project template
  """

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

  def example_post(name) do
    Gonz.Post.create(
      "My fine post on #{name}",
      content: """
      We got *italics*, **bold**, [links](https://elixir-lang.org/), and quotes:

      > To be or not to be

      There is also code snippet support, and most other things you expect:

      ```elixir
      Gonz.Post.create("Mypage", nav_item?: true, content: "Yo!")
      ```

      ![The Gonz](https://media.giphy.com/media/gqG3dwMXRBaBq/giphy.gif)
      """
    )
  end

  def layout_template(name) do
    """
    <!DOCTYPE html>
    <html>
      <head>
        <title>#{name}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="generator" content="Gonz" />

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
        <h2><a href="#\{post.category}/#\{post.filename}">#\{post.markdown.front_matter.title}</a></h2>
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
        <li><a href="#\{url}">#\{item.markdown.front_matter.title}</a></li>
        \"\"\"
      end) %>
      </ul>
    </div>
    """
  end
end
