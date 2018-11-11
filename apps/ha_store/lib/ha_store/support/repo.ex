defmodule HaStore.Repo do
  use Ecto.Repo, otp_app: :ha_store
  use Paginator
end
