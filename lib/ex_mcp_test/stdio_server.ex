defmodule ExMCP.StdioServer do
  use GenServer

  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Process.flag(:trap_exit, true)
    Logger.info("ExMCP server is starting")
    send(self(), :read_line)
    {:ok, %{}}
  end

  @impl true
  def handle_info(:read_line, state) do
    case IO.read(:line) do
      :eof ->
        Logger.info("stdin closed by parent process, shutting down")
        {:stop, :normal, state}

      {:error, reason} ->
        Logger.error("stdin read error: #{inspect(reason)}")
        {:stop, reason, state}

      line ->
        handle_line(line)
        send(self(), :read_line)
        {:noreply, state}
    end
  end

  @impl true
  def terminate(reason, _state) do
    Logger.info("stdio server terminating, reason: #{inspect(reason)}")
    :ok
  end

  defp handle_line(line) do
    case Jason.decode(line) do
      {:ok, %{"method" => "cancelled"} = request} ->
        Logger.info("request #{inspect(request["params"])} canceled\n")

      # {:ok, %{"method" => "notifications/initialized"} = _request} ->
      #   Logger.info("Client initialized - we can send requests\n")

      # {:ok, %{"method" => "notifications/" <> _} = request} ->
      #   Logger.info("Ignoring notification #{inspect request}\n")

      {:ok, %{} = request} ->
        with %{"id" => id} = json_response when not is_nil(id) <-
               request |> ExMCP.Router.handle() |> PhxJsonRpcWeb.Views.Helpers.render_json() do
          Logger.info("Replying to #{inspect(request)} with #{inspect(json_response)}\n")
          IO.write(Jason.encode!(json_response) <> "\n")
        end

        :ok

      {:error, _} ->
        error_response = %{
          jsonrpc: "2.0",
          error: %{code: -32700, message: "Parse error"},
          id: ""
        }

        IO.write(Jason.encode!(error_response) <> "\n")
    end
  end
end
