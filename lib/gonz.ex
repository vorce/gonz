defmodule Gonz do
  @moduledoc """
  Documentation for Gonz.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Gonz.hello()
      :world

  """
  def now_iso8601() do
    DateTime.to_iso8601(DateTime.utc_now())
  end
end
