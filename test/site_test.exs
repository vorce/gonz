defmodule Gonz.SiteTest do
  use ExUnit.Case

  alias Gonz.Site

  describe "filename_from_title/2" do
    test "prepends datetime to post" do
      title = "test title here"
      "./posts/" <> filename = Site.filename_from_title("posts", title)
      date = String.slice(filename, 0, 20)

      assert {:ok, _, _} = DateTime.from_iso8601(date)
    end
  end

  describe "sanitize_title/1" do
    test "strips dash" do
      input = "my title - yes!"
      assert Site.sanitize_title(input) == "my-title-yes"
    end
  end
end
