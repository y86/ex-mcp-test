import Config

# Configure the console backend
config :logger,
  backends: [:console]

config :logger, :console,
  device: :standard_error,
  format: "$date $time | $level | $metadata| $message\n",
  metadata: :all,
  utc_log: true,
  level: :info
