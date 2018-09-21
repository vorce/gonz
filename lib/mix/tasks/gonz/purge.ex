defmodule Mix.Tasks.Gonz.Purge do
  @moduledoc """
  Removes all gonz created stuff
  """
  use Mix.Task

  @shortdoc "Remove all gonz related files and directories"

  def run([]), do: run([Gonz.Build.default_output_dir()])

  def run([output]) do
    known_stuff = [
      Gonz.Site.drafts_dir(),
      Gonz.Site.posts_dir(),
      Gonz.Site.pages_dir(),
      Gonz.Site.themes_dir(),
      Gonz.Site.site_assets_dir(),
      output
    ]

    confirmation =
      IO.gets("Are you sure you want to remove the following files and directories:\n#{inspect(known_stuff)}, y/n? ")

    case confirmation do
      yes when yes in ["y\n", "yes\n", "Y\n"] ->
        IO.puts("Removing all gonz related files and directories!")
        Enum.each(known_stuff, &File.rm_rf/1)

      _other ->
        IO.puts("Skipping purge")
        :ok
    end
  end
end
