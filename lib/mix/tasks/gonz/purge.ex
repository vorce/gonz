defmodule Mix.Tasks.Gonz.Purge do
  @moduledoc """
  Removes all gonz created stuff
  """
  use Mix.Task

  @shortdoc "Remove all gonz related files and directories"

  def run(_args) do
    # Ask for confirmation!
    IO.puts("Removing all gonz related files and directories!")
    known_stuff = ["./drafts", "./posts", "./pages", "./themes", "./site.yml", "./build"]
    Enum.each(known_stuff, &File.rm_rf/1)
  end
end
