defmodule HaServer.ErrorView do
  use HaServer, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("401.json", _assigns) do
    %{
      error: %{
        type: "uauthenticated"
      }
    }
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
