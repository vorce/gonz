[![white flower daisy fing shawiwey by Mark Gonzales](white_flower_daisy_fing_shawiwey.jpg)](https://hvw8.com/exhibitions/artists/mark-gonzales)

[![Hex.pm](https://img.shields.io/hexpm/v/gonz.svg)](https://hex.pm/packages/gonz) ![Build status](https://github.com/vorce/gonz/actions/workflows/action.yml/badge.svg) [![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=vorce/gonz)](https://dependabot.com) [![Casual Maintenance Intended](https://casuallymaintained.tech/badge.svg)](https://casuallymaintained.tech/)

# gonz

> I can write anything and just put it in a zine, and then it's out there. It is like blogging but on paper. It is what I started to do before the computers were all popular.

Static site generator. **Heavily** inspired by [Obelisk](https://github.com/BennyHallett/obelisk) (thanks for a great project!).

## Quick start

Start a new elixir project:

`mix new mysite`

Add gonz dependency:

```elixir
defp deps do
  [
    {:gonz, "~> 3.1"}
  ]
end
```

Use gonz to scaffold your site skeleton:

    mix deps.get
    mix deps.compile
    mix gonz.new MyAwesomeSite
    mix gonz.build
    mix gonz.serve

Open [http://localhost:4000/](http://localhost:4000/) in your browser.

Now you probably want to start editing the default theme (or create a new one). See [my own personal site](https://github.com/vorce/forvillelser/tree/master/themes/forvillelser) for an example.

## Goals

Some things I've had in mind while hacking on gonz:

- Use case: personal homepage with blog like posts, and static pages.
- Write posts and pages in [Markdown](http://daringfireball.net/projects/markdown/syntax).
- Support themes / templates with [EEx](https://hexdocs.pm/eex/EEx.html) only. I doubt I will add support for anything else
- Simple to use and get started with, using [mix](https://hexdocs.pm/mix/Mix.html) tasks
- Few dependencies
- Clarity over performance. Performance shouldn't be horrible, but is not a top priority at this point.

## Features

- Write pages and posts in Markdown
- "Themes" with EEx templates
- Front matter is specified as an elixir map
- You can put categories on pages/posts, then themes can handle them in whatever way they wish.
- There is a special category `:nav_item` that will enable themes to handle some pages as navigation items.

## Mix tasks

These are the most common ways to interact with gonz while building your site.

### `gonz.new [site-name]`

Creates a new gonz project/site.

Arguments:
- site-name: Optional name of the site to create, just determines how the bootstrapped site will look.

### `gonz.post <post-title>`

Creates a new post in `posts/` with the specified title.

Example: `mix gonz.post "My amazing post about Things"`

Arguments:
- post-title: Required title of the post

### `gonz.build [theme-name] [output-directory] [posts-per-page]`

Builds the site.

Arguments:
- theme-name: Optional name of the theme to use, defaults to "default"
- output-directory: Optional name of the build/output directory. Defaults to "./build"
- posts-per-page: Optional number of pages per index page. Defaults to 10.

### `gonz.serve` [output-directory] [port]

Serves the built site for local development.

Arguments:
- output-directory: Optional name of the build/output directory to serve files from. Defaults to "./build"
- port: Optional port of the http server, defaults to 4000.

### `gonz.purge [output-directory]`

Removes all files related to the site. This can give you a fresh start. Mostly used for manual testing new sites easily.

Arguments:
- output-directory: Optional name of the build/output directory. Defaults to "./build"

### Planned tasks

`mix gonz.page title`

### Adding static assets to your site

#### Example: You want to add the image "pangolin.png" to a post

1. Copy pangolin.png to "./assets/images/" (you may have to create the "images" subdir)
2. In your post file markdown, insert: `![A cool pangolin](./assets/images/pangolin.png)`
3. Build the site 🎉

### Themes

The easiest way to create your own theme is to copy the default one, and use it as a reference on how and what data is available. Example of a custom theme can be seen in [forvillelser](https://github.com/vorce/forvillelser)

The exact API for themes are subject to change. The available data for the theme templates are returned by  [`Document.to_assigns/1`](https://github.com/vorce/gonz/blob/master/lib/gonz/document.ex#L55)

#### Building your site with a non-default theme

**If you use a custom theme, don't forget to specify the name of it when you build your site, ex: `mix gonz.build mythemename build 10`**

If this gets repetitive I suggest you create a target in a Makefile.

## Github pages howto

- Enable github pages for your project (pick "Master branch /docs folder" source option)
- Create a `docs` dir in your project root
- When building the site make sure you specify the docs dir as the output directory: `mix gonz.build <theme> docs`
- Add all files in `docs` and commit, push. 🎉

## Netlify howto

Even simpler! My own site uses Netlify, so you can copy the Makefile in [Forvillelser](https://github.com/vorce/forvillelser).

- Then configure the project in netlify to use `make` as the build command, and `build` as the publish directory.
- Now all you need to do is write your posts, commit and push them and netlify will build the site and publish it. 🎉

## Why

Why create something new instead of using Obelisk, Serum, or Coil?

Short answer: Fun, learning, and flexibility.

Longer answer: I checked out all of these projects. Out of the three I really liked how Obelisk looked to use,
but it did not compile out of the box. Once changing some dependencies (plug), it compiled, but when running it crashed.
I looked closer at the github page and noticed that the project was a bit abandoned. Then I figured  "meh, let's code"!

## Todo

- What about drafts..
- Rethink code structure, can simplify a lot of things and make it more consistent I think. The clarity bullet in the goals section is not quite there yet :)
- Low hanging speed ups (Task.async?)
- Assets. Right now it's all or nothing. What if I want to publish a separate page that needs some assets that nothing else needs?

## Upgrading themes from 2.x to 3.x

1. Change from Document.category to Document.item
2. Change `nav_item: true` to `categories: [:nav_item]` in front matter
