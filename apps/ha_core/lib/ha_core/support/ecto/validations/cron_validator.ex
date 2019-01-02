defmodule HaCore.Validations.CronValidator do
  @moduledoc false
  import Ecto.Changeset
  alias Crontab.CronExpression.Parser

  def validate(changeset, field) do
    cron = get_change(changeset, field)
    if cron do
      case Parser.parse(cron) do
        {:ok, _} = result ->
          changeset
        _ ->
          add_error(changeset, field, "Invalid cron tab")
      end
    else
      changeset
    end
  end

end
