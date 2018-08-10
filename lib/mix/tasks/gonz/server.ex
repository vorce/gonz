defmodule Mix.Tasks.Gonz.Server do
  @moduledoc """
  Shows help for gonz tasks
  """
  use Mix.Task

  @shortdoc "Serve your gonz site locally"
  @task_name "gonz.server"

  def run(_) do
    Application.start(:cowboy)
    Application.start(:plug)
    IO.puts("Starting Cowboy server. Browse to http://localhost:4000/")

    {:ok, pid} = Plug.Adapters.Cowboy2.http(Gonz.Plug.Server, [])

    :timer.sleep(:infinity)
  end
end
