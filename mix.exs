defmodule BeanApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :bean_app,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :elastic],
      mod: {BeanApp.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elastic, "~> 3.5.0"},
      {:poison,  "~> 3.1.0"},
      {:honeydew, "~> 1.4.3"},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end
end
