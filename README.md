# gonz

> I can write anything and just put it in a zine, and then it's out there. It is like blogging but on paper. It is what I started to do before the computers were all popular.

Static site generator. Heavily inspired by Obelisk.

Why create something new instead of using Obelisk, Serum, or Coil? Fun, learning, and flexibility.

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
    ...
    mix gonz.build
    ...
    mix gonz.server

Open http://localhost:4000 in your browser.

## Adding content

TODO
