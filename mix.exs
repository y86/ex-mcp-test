defmodule ExMCP.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_mcp_test,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExMCP.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:phx_json_rpc, "~> 0.7.0"}
    ]
  end
end
