defmodule ExMCP.Router do
  use PhxJsonRpc.Router,
    otp_app: :rpc_router,
    schema: "priv/static/mcp-openrpc.json",
    version: "2.0",
    max_batch_size: 20

  alias ExMCP.MainController
  alias ExMCP.PromptsController
  alias ExMCP.ResourcesController
  alias ExMCP.ToolsController

  ## Middleware group (optional)
  # Uncomment the line below, when neccessary (see `PhxJsonRpc.Router.Middleware` for usage)
  # middleware([AuthMiddleware])

  ## Tools's service
  rpc("initialize", MainController, :initialize)
  rpc("notifications/initialized", MainController, :notifications_initialized)

  rpc("prompts/list", PromptsController, :list)
  rpc("resources/list", ResourcesController, :list)

  rpc("tools/list", ToolsController, :list)
  rpc("tools/call", ToolsController, :call)
end
