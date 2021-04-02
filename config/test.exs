use Mix.Config

config :trifolium,
  token: "MY_TOKEN",
  http_client: Trifolium.HTTPClientMock

config :logger, level: :info
