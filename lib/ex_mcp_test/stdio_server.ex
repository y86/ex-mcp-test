defmodule ExMCP.StdioServer do
  use GenServer

  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Process.flag(:trap_exit, true)
    IO.write(:stderr, "ExMCP server starting\n")
    send(self(), :read_line)
    {:ok, %{}}
  end

  @impl true
  def handle_info(:read_line, state) do
    case IO.read(:line) do
      :eof ->
        IO.write(:stderr, "stdin closed by parent process, shutting down\n")
        {:stop, :normal, state}

      {:error, reason} ->
        IO.write(:stderr, "stdin read error: #{inspect(reason)}\n")
        {:stop, reason, state}

      line ->
        handle_line(line)
        send(self(), :read_line)
        {:noreply, state}
    end
  end

  @impl true
  def terminate(reason, _state) do
    IO.write(:stderr, "stdio server terminating, reason: #{inspect(reason)}\n")
    :ok
  end

  defp handle_line(line) do
    case Jason.decode(line) do
      {:ok, %{"method" => "cancelled"} = request} ->
        IO.write(:stderr, "request #{inspect request["params"]} canceled\n\n")

      {:ok, %{"method" => "notifications/initialized"} = _request} ->
        IO.write(:stderr, "Client initialized - we can send requests\n\n")

      {:ok, %{"method" => "notifications/" <> _} = request} ->
        IO.write(:stderr, "Ignoring notification #{inspect request}\n\n")

      {:ok, %{} = request} ->
        json_response =
          request
          |> ExMCP.Router.handle()
          |> PhxJsonRpcWeb.Views.Helpers.render_json()

        IO.write(:stderr, "Replying to #{inspect request} with #{inspect json_response}\n\n")
        IO.write(Jason.encode!(json_response) <> "\n")

      {:error, _} ->
        error_response = %{
          jsonrpc: "2.0",
          error: %{code: -32700, message: "Parse error"},
          id: nil
        }

        IO.write(Jason.encode!(error_response) <> "\n")
    end
  end
end
