defmodule Gonz.BuildTest do
  use ExUnit.Case

  alias Gonz.Build

  describe "pages_build_dir/1" do
    test "is output" do
      output = "whatever"
      assert Build.pages_build_dir(output) == output
    end
  end

  describe "write_document_as_html/4" do
    test "" do
    end
  end
end
