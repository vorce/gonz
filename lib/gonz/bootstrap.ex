defmodule Gonz.Bootstrap do
  @moduledoc """
  Project template
  """

  def post_template() do
    """
    <article class="h-entry">
      <h2 class="p-name">
        <a href="<%= @filename %>"><%= @front_matter.title %></a>
      </h2>
      <div class="e-content">
        <%= @content %>
      </div>
    </article>
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
      Gonz.Post.create("Mypage", categories: [:nav_item, :foo, "bar"], content: "Yo!")
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
        <meta name="Description" content="<%= @meta.description %>">

        <!-- Thanks to https://webbkoll.dataskydd.net/ -->
        <meta name="referrer" content="no-referrer" /> <!-- Referrer Policy -->
        <meta http-equiv="Content-Security-Policy" content="script-src 'self' 'unsafe-inline'" /> <!-- Content Security Policy -->

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
        <article class="h-entry">
          <h2 class="p-name"><a href="#\{post.type}/#\{post.filename}">#\{post.markdown.front_matter.title}</a></h2>
            <div class="e-content">
              #\{post.html_content}
            </div>
        </article>
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
      <h1><%= @front_matter.title %></h1>
      <hr />
      <%= @content %>
    </div>
    """
  end

  def navigation_template() do
    """
    <nav>
      <ul>
      <%= Enum.map(@items, fn item ->
        url = if item.type == :posts do
          "#\{@href_prefix}#\{item.type}/#\{item.filename}"
        else
          "#\{@href_prefix}#\{item.filename}"
        end
        \"\"\"
        <li><a href="#\{url}">#\{item.markdown.front_matter.title}</a></li>
        \"\"\"
      end) %>
      </ul>
    </nav>
    """
  end
end
