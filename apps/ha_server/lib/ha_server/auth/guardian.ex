defmodule HaServer.Guardian do
  @moduledoc """
  This module defines callbacks for verifying JWT tokens
  """
  use Guardian, otp_app: :ha_server

  def subject_for_token(resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    sub = to_string(resource.id)
    {:ok, sub}
  end
  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    id = claims["sub"]
    IO.inspect claims
    resource = nil
    {:ok,  resource}
  end
  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end

  def get_secret_key() do
    %{
      "alg": "RS256",
      "e": "AQAB",
      "kid": "We7OIFK6KKwLpDuShEIPSQnHjA+JAhEl3TAxu24AQ7w=",
      "kty": "RSA",
      "n": "iK5OIRQQpaMfDeD0FhfcS-y2zP0m5lzjrPv1y5QPS4vGOtBt26ygyuqpPvjrl6L7R6puwcLQhBI3QU_QEs2KxtwV7LPA8kWzi7DQybF1ecKmcKS-UzalKKzzvcR09aUVRH2rr4WHn_k1O8xN1puPCwAtYJK6oC6aWpiMJJ0IhlNPrDARxTZsvvfv54W0kJCsO1qGbHk_pMUhp5MHA4768pFJiQ1mgfwP7H9ObKXrwz-8kgVJsvzRQWtAw-FP6kqPpQudr0lWHln1oBjDMuAuwK9DFmZt9O57ftqx8C5_8lnw1GBgEuB5GrJYwj7d8Ivo458ZCZ0Og5rb2j9EyrHjMQ",
      "use": "sig"
    }
  end

end
