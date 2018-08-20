defmodule Gonz.DocumentTest do
  use ExUnit.Case

  alias Gonz.Document

  describe "html_filename/2" do
    test "generates a nice filename for posts" do
      md = %Gonz.Markdown{
        filename: "2018-08-11T17:51:32.905958Z-my-older-post.md",
        front_matter: %Gonz.Markdown.FrontMatter{
          created_at: "2018-08-09T17:51:32.905935Z",
          title: "My older post"
        }
      }

      assert Document.html_filename(md, :posts) == "2018-08-09T17:51-my-older-post"
    end

    test "generates nice filename for pages" do
      md = %Gonz.Markdown{
        filename: "about.md",
        front_matter: %Gonz.Markdown.FrontMatter{
          created_at: "2018-08-09T17:51:32.905935Z",
          title: "About"
        }
      }

      assert Document.html_filename(md, :pages) == "about"
    end

    test "replaces some charcters with dash" do
      md = %Gonz.Markdown{
        filename: "2018-08-11T17:51:32.905958Z-my-older-post.md",
        front_matter: %Gonz.Markdown.FrontMatter{
          created_at: "2018-08-09T17:51:32.905935Z",
          title: "Yo! Hey, there. Friendo?: ok; yeah (yeah) [heh] {foo}"
        }
      }

      assert Document.html_filename(md, :posts) == "2018-08-09T17:51-yo-hey-there-friendo-ok-yeah-yeah-heh-foo"
    end
  end
end
