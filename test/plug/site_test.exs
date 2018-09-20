defmodule Gonz.Plug.SiteTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Gonz.Plug.Site

  test "returns 404 for missing index file" do
    conn = conn(:get, "/")

    conn = Site.call(conn, build_dir: "this_should_not_exist")

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "return static file that exist" do
    conn = conn(:get, "mix.exs")

    conn = Site.call(conn, build_dir: "./")

    assert conn.state == :file
    assert conn.status == 200
  end
end
