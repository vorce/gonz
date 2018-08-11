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
- Support themes / templates with `EEx` only. I doubt I will add support for anything else
- Simple to use and get started with, using `mix` tasks
- Few dependencies
- Clarity over performance. Performance shouldn't be horrible, but is not a top priority at this point.

## Quick start

`mix new mysite`

```elixir
defp deps do
  [
    {:gonz, "~> 0.1" }
  ]
end
```

    mix deps.get
    mix deps.compile
    mix gonz.new example
    mix gonz.build

Open [build/index.html](build/index.html) in your browser.

## Adding content

TODO

Planned tasks:

`mix gonz.post title`
`mix gonz.page title`

## Todo

- Build the individual posts
- Do we really need the `gonz.server` task? Can't the user just open the site in the browser? This would reduce code and dependenices.
- Rethink code structure, can simplify a lot of things and make it more consistent I think.
- Low hanging speed ups (Task.async?)
- What about site.yml, do we need it? Would it nicer in some more elixiry format?
