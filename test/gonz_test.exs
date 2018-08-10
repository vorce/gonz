defmodule GonzTest do
  use ExUnit.Case
  doctest Gonz

  test "greets the world" do
    assert Gonz.hello() == :world
  end
end
