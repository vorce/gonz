defmodule Mix.Tasks.Gonz.Post do
  @moduledoc """
  Task to create a new post
  """
  use Mix.Task

  @shortdoc "Create a new post"

  def run([title]) do
    case Gonz.Post.create(title) do
      :ok ->
        IO.puts("Created new post with title: \"#{title}\" in posts/")
      other ->
        IO.puts("Failed to create new post with title: \"#{title}\", reason: #{inspect(other)}")
    end
  end
end
