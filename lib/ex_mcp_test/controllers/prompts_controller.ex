defmodule ExMCP.PromptsController do
  @moduledoc "Controller to handle MCP's promptss services"

  def list(%{} = _params, _context) do
    %{prompts: []}
  end
end
