defmodule Mix.Tasks.Gonz.Serve do
  @moduledoc """
  Starts a local web server to serve the built site
  """

  def run([]), do: run(["build", "4000"])

  def run([build_dir, port_str]) do
    port = String.to_integer(port_str)
    Application.start(:cowboy)
    Application.start(:plug)
    IO.puts("Starting web server. Site at http://localhost:#{port}/ serving files from dir: #{build_dir}")

    {:ok, _} = Plug.Adapters.Cowboy2.http(Gonz.Plug.Site, [build_dir: build_dir], port: port)

    :timer.sleep(:infinity)
  end
end
