defmodule Gonz.MixProject do
  use Mix.Project

  def project do
    [
      app: :gonz,
      version: "4.0.0",
      elixir: "~> 1.13",
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
      {:earmark, "~> 1.4"},
      {:ranch, "~> 1.8"},
      {:plug, "~> 1.10"},
      {:cowboy, "~> 2.8"},
      {:plug_cowboy, "~> 2.0"},
      {:ex_doc, "~> 0.26"}
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
