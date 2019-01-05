defmodule HaStorage.Hashes.HashStore.Postgres do
  @moduledoc false
  use HaStorage.Hashes.HashStore
  import Ecto.Query

  alias HaStorage.Hashes.{InsertMutation, UpdateMutation, DeleteMutation}
  alias HaStorage.Hashes.Hash

  defmodule Repo do
    @moduledoc false
    use Ecto.Repo, otp_app: :ha_storage
  end

  @impl true
  def start_link(opts) do
    Repo.start_link(opts)
  end

  @impl true
  def get(ids) do
    Repo.all(
      from h in Hash,
      where: h.key in ^ids
    )
  end

  @impl true
  def put(hashes) do
    hashes =
      for %Hash{value: value} = hash <- hashes do
        hash
        |> Map.put(:status, "inserted")
        |> Map.put(:state, hash_state(value))
        |> Map.put(:ts, NaiveDateTime.utc_now())
        |> Map.take(~w(key value status state table_id ts)a)
      end
    update = from h in Hash, update: [
      set: [
        value: fragment("EXCLUDED.value"),
        previous: h.value,
        state: fragment("EXCLUDED.state"),
        status: fragment("
          CASE
            WHEN EXCLUDED.state <> ? THEN 'updated'::text
            WHEN EXCLUDED.state = ? THEN 'ignored'::text
          END
        ", h.state, h.state)
      ]
    ]
    opts = [
      returning: true,
      on_conflict: update,
      conflict_target: [:key]
    ]
    case Repo.insert_all(Hash, hashes, opts) do
      {_count, saved} ->
        diffs =
          saved
          |> Enum.map(&collect_hash/1)
          |> Enum.reject(&is_nil/1)
        {:ok, diffs}
      other ->
        {:error, other}
    end
  end
  defp collect_hash(%Hash{table_id: table_id, key: key, ts: ts, status: "inserted"} = hash),
    do: %InsertMutation{table_id: table_id, key: key, value: hash.value, ts: ts}
  defp collect_hash(%Hash{table_id: table_id, key: key, ts: ts, status: "updated"} = hash),
    do: %UpdateMutation{table_id: table_id, key: key, old: hash.previous, new: hash.value, ts: ts}
  defp collect_hash(%Hash{table_id: table_id, key: key, ts: ts, status: "deleted"} = hash),
    do: %DeleteMutation{table_id: table_id, key: key, value: hash.value, ts: ts}
  defp collect_hash(%Hash{status: "ignored"} = _hash),
    do: nil

  def hash_state(state) when is_map(state), do: Poison.encode!(state) |> hash_state
  def hash_state(state) when is_binary(state) do
    :crypto.hash(:md5, state) |> Base.encode16(case: :lower)
  end

end
