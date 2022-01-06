defmodule Mix.Tasks.Gonz.Serve do
  @moduledoc """
  Starts a local web server to serve the built site
  """

  @default_port "4000"

  def run([]), do: run(["build", @default_port])

  def run([build_dir]), do: run([build_dir, @default_port])

  def run([build_dir, port_input]) do
    port = String.to_integer(port_input)
    Application.start(:telemetry)

    IO.puts("Starting web server. Site at http://localhost:#{port}/ serving files from dir: #{build_dir}")

    {:ok, _} = Plug.Cowboy.http(Gonz.Plug.Site, [build_dir: build_dir], port: port)

    :timer.sleep(:infinity)
  end
end
