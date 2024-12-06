# ExMCP Test Server

An MCP (Model Context Protocol) server implementation in Elixir that provides a test implementation for experimenting with the protocol.

## Features

- JSON-RPC 2.0 compliant server implementation
- Standard MCP protocol methods supported
- Pluggable validation and middleware pipeline
- Schema-driven request/response validation
- OpenRPC specification included

## Architecture

The server is built using:
- `PhxJsonRpc` for the RPC layer 
- `ExJsonSchema` for schema validation
- `Jason` for JSON encoding/decoding

## Usage

Run the server locally:

```sh
mix run --no-halt
```

## Configuration
The best way to run the model is to generate a release with

```sh
mix release
```
and add it to to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "ex-mcp-test": {
      "command": "path/to/your/realease/bin/my_app",
      "args": [
        "start"
      ]
    }
  }
}
```

## Development
Requirements:

- Elixir 1.14+
- Mix

# Install dependencies:

```sh
mix deps.get
```

Run tests:

```sh
mix test
```

## API Documentation
The server implements the following MCP methods:

```
initialize - Initialize the server
notifications/initialized - Handle initialization notification

prompts/list - List available prompts
resources/list - List available resources

tools/list - List available tools
tools/call - Call a specific tool
```

The OpenRPC specification can be found in `priv/static/mcp-openrpc.json`.

## License
This project is licensed under the MIT License - see the LICENSE file for details.