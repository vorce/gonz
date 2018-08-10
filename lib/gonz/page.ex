defmodule Gonz.Page do
  def create(title) do
    File.write(Gonz.Site.filename_from_title("pages", title), Gonz.Template.page(title))
  end
end
