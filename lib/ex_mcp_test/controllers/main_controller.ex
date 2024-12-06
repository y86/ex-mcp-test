defmodule ExMCP.MainController do
  @moduledoc "Controller to handle MCP's protocol main methods"

  def initialize(%{} = _params, _context) do
    %{
      protocolVersion: "2024-11-05",
      capabilities: %{
        # logging: %{},
        # prompts: %{
        #   listChanged: false
        # },
        # resources: %{
        #   subscribe: false,
        #   listChanged: false
        # },
        tools: %{
          listChanged: true
        }
      },
      serverInfo: %{
        name: "ExMCPServer",
        version: "1.0.0"
      }
    }
  end

  def initialized(%{} = _params, _context) do
    nil
  end
end
