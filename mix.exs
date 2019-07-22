defmodule Gonz.MixProject do
  use Mix.Project

  def project do
    [
      app: :gonz,
      version: "3.0.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # convert markdown to html
      {:earmark, "~> 1.2"},
      {:plug, "~> 1.6"},
      {:cowboy, "~> 2.4"},

      # Needed because elixir 1.6
      {:ex_doc, "~> 0.21.1", only: :dev}
    ]
  end

  defp description() do
    "A bland static site generator"
  end

  defp package() do
    [
      maintainers: ["joel@vorce.se"],
      licenses: ["LGPL-3.0"],
      links: %{"GitHub" => "https://github.com/vorce/gonz"}
    ]
  end
end
