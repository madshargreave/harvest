use Mix.Config

config :ha_storage, HaStorage.Records.DynamoStore,
  table_name: System.get_env("AWS_DYNAMO_TABLE_NAME")

# Configure your database
config :ha_storage, HaStorage.Hashes.HashStore.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: 10

config :ha_storage, HaStorage.Records.DynamoStore.Repo,
  adapter: Ecto.Adapters.DynamoDB,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_DEFAULT_REGION"),
  debug_requests: false	# ExAws option to enable debug on aws http request.
  # dynamodb: [
  #   scheme: "https://",
  #   host: "localhost",
  #   port: 8000,
  #   region: System.get_env("AWS_DEFAULT_REGION")
  # ]

config :ha_storage, HaStorage.Records.S3Store,
  bucket_name: System.get_env("TABLE_BUCKET_NAME")

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: System.get_env("AWS_DEFAULT_REGION")
