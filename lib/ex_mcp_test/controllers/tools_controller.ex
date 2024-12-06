defmodule ExMCP.ToolsController do
  @moduledoc "Controller to handle MCP's tools services"

  def list(%{} = _params, _context) do
    %{
      tools: [
        %{
          name: "query",
          description: "Run a read-only SQL query",
          inputSchema: %{
            type: "object",
            properties: %{
              sql: %{type: "string"}
            }
          }
        },
        %{
          name: "echo",
          description: "Returns provided text",
          inputSchema: %{
            type: "object",
            properties: %{
              text: %{type: "string"}
            }
          }
        }
      ]
    }
  end

  def call(%{"name" => name, "arguments" => arguments} = _params, context) do
    {content, error?} = call_tool(name, arguments, context)

    %{content: content, isError: error?}
  end

  defp call_tool("echo", arguments, _context) do
    case arguments do
      %{"text" => text} -> {[%{type: "text", text: text}], false}
      _ -> {[%{type: "text", text: "invalid arguments - `text` is missing"}], true}
    end
  end

  defp call_tool("query", arguments, _context) do
    case arguments do
      %{"sql" => _sql} ->
        query_result = [
          %{name: "Sample Name", age: "Sample Age"}
        ]

        {[%{type: "text", text: Jason.encode!(query_result)}], false}

      _ ->
        {[%{type: "text", text: "invalid arguments - `sql` is missing"}], true}
    end
  end
end
