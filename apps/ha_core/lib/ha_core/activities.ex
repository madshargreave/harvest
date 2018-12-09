defmodule HaCore.Activities do
  @moduledoc """
  The Activities context.
  """
  alias HaCore.Activities.Store, as: ActivityStore

  defdelegate count_activities, to: ActivityStore, as: :count
  defdelegate list_activities, to: ActivityStore, as: :list
  defdelegate get_activity!(id), to: ActivityStore, as: :get!
  defdelegate create_activity(attrs), to: ActivityStore, as: :create
  defdelegate update_activity(activity, attrs), to: ActivityStore, as: :update
  defdelegate delete_activity(activity), to: ActivityStore, as: :delete

end
