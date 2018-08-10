defmodule Gonz.Post do
  @moduledoc """
  Post stuff
  """

  def create(title) do
    File.write(filename_from_title(title), Gonz.Template.post(title))
  end

  def filename_from_title(title) do
    date_string =
      DateTime.utc_now()
      |> DateTime.to_date()
      |> Date.to_string()

    safe_title = sanitize_title(title)
    "./posts/#{date_string}-#{safe_title}.md"
  end

  def sanitize_title(title) do
    title
    |> String.downcase()
    |> String.replace(" ", "-")
  end
end
