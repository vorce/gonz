defmodule Mix.Tasks.Gonz.New do
  @moduledoc """
  Shows help for gonz tasks
  """
  use Mix.Task

  @shortdoc "Create a new gonz site"
  @task_name "gonz.new"

  def run([]), do: run(["gonz"])

  def run([name]) do
    {microseconds, result} =
      :timer.tc(fn ->
        Gonz.Site.new(name)
      end)

    case result do
      ok when ok in [:ok, {:ok, :ok}] ->
        IO.puts("Created new site: #{name}, took: #{microseconds * 0.000001}s")

      error ->
        IO.puts(:stderr, "Something went wrong: #{inspect(error)}")
    end

    :ok
  end

  def run(args) do
    IO.puts(
      :stderr,
      "Expected zero or one argument to `#{@task_name}`, as the name of the new project. Got: #{length(args)} arguments"
    )

    :ok
  end
end
