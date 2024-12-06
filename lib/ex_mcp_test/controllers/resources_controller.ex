defmodule ExMCP.ResourcesController do
  @moduledoc "Controller to handle MCP's resourcess services"

  def list(%{} = _params, _context) do
    %{resources: []}
  end
end
