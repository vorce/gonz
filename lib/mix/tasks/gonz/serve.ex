defmodule Mix.Tasks.Gonz.Serve do
  @moduledoc """
  Starts a local web server to serve the built site
  """

  def run([]), do: run(["build"])

  def run([build_dir]) do
    Application.start(:cowboy)
    Application.start(:plug)
    IO.puts("Starting web server. Site at http://localhost:4000/ serving files from dir: #{build_dir}")

    {:ok, _} = Plug.Adapters.Cowboy2.http(Gonz.Plug.Site, build_dir: build_dir)

    :timer.sleep(:infinity)
  end
end
