[![Hex.pm](https://img.shields.io/hexpm/v/gonz.svg)](https://hex.pm/packages/gonz) [![Build Status](https://travis-ci.org/vorce/gonz.svg?branch=master)](https://travis-ci.org/vorce/gonz)

# gonz

> I can write anything and just put it in a zine, and then it's out there. It is like blogging but on paper. It is what I started to do before the computers were all popular.

Static site generator. **Heavily** inspired by Obelisk (thanks for a great project!).

## Why

Why create something new instead of using Obelisk, Serum, or Coil?

Short answer: Fun, learning, and flexibility.

Longer answer: I checked out all of these projects. Out of the three I really liked how Obelisk looked to use,
but it did not compile out of the box. Once changing some dependencies (plug), it compiled, but when running it crashed.
I looked closer at the github page and noticed that the project was a bit abandoned. Then I figured  "meh, let's code"!

## Goals

Some things I've had in mind while hacking on gonz:

- Use case: personal homepage with blog like posts, and static pages.
- Write posts and pages in [Markdown](http://daringfireball.net/projects/markdown/syntax).
- Support themes / templates with [EEx](https://hexdocs.pm/eex/EEx.html) only. I doubt I will add support for anything else
- Simple to use and get started with, using [mix](https://hexdocs.pm/mix/Mix.html) tasks
- Few dependencies
- Clarity over performance. Performance shouldn't be horrible, but is not a top priority at this point.

## Quick start

`mix new mysite`

```elixir
defp deps do
  [
    {:gonz, "~> 0.1"}
  ]
end
```

    mix deps.get
    mix deps.compile
    mix gonz.new MyAwesomeSite
    mix gonz.build

Open [build/index.html](build/index.html) in your browser.

## Adding content

TODO

Planned tasks:

`mix gonz.post title`

`mix gonz.page title`

## Features

- Write pages and posts in Markdown
- "Themes" with EEx templates
- A page can be marked as a navigation item, which can be handled in the templates.

### Themes

To create your own theme I suggest you copy the default one, and use it as a reference on how and what data is available. Example of a custom theme can be seen in [forvillelser](https://github.com/vorce/forvillelser)

The exact API for themes are subject to change.

If you use a custom theme, don't forget to specify the name of it when you build your site, ex: `mix gonz.build mythemename`

If this gets old I suggest you create a target in a Makefile.

## Todo

- What about drafts..
- Rethink code structure, can simplify a lot of things and make it more consistent I think.
- Low hanging speed ups (Task.async?)
