use Mix.Config

# Configure your database
config :ha_storage, HaStorage.Hashes.HashStore.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: 10

config :ha_storage, HaStorage.Records.S3Store,
  bucket_name: System.get_env("TABLE_BUCKET_NAME")

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: System.get_env("AWS_DEFAULT_REGION")
