defmodule Gonz.Post do
  @moduledoc """
  Post stuff
  """

  def create(title) do
    File.write(Gonz.Site.filename_from_title("posts", title), Gonz.Bootstrap.post(title))
  end
end
