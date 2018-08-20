defmodule Gonz do
  @moduledoc """
  Documentation for Gonz.
  """

  @doc """
  Shorthand for now in iso8601
  """
  def now_iso8601() do
    DateTime.to_iso8601(DateTime.utc_now())
  end
end
