defmodule Mix.Tasks.Gonz.Help do
  @moduledoc """
  Shows help for gonz tasks
  """
  use Mix.Task

  @shortdoc "Gonz help"
  @help_text """
  Bla bla
  """

  def run(_args) do
    IO.puts(@help_text)
  end
end
