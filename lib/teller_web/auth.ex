defmodule TellerWeb.Auth do
  @moduledoc """
  A module plug that verifies the Authentication token in the request headers and
  assigns `:username`. The authorization header value may look like
  `Basic xxxxxxx`.
  """

  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_api_key()
    |> verify_api_key()
    |> case do
      {:ok, username} -> assign(conn, :username, username)
      _unauthorized -> assign(conn, :username, nil)
    end
  end

  def authenticate_api_user(conn, _opts) do
    if Map.get(conn.assigns, :username) do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(TellerWeb.ErrorView)
      |> render(:"401")
      # Stop any downstream transformations.
      |> halt()
    end
  end

  defp get_api_key(conn) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> key] ->
        if Base.decode64!(key) == ":" do
          nil
        else
          "test_" <> key = String.slice(Base.decode64!(key), 0..-2)
          key
        end

      _ ->
        nil
    end
  end

  defp verify_api_key(key) when is_binary(key) do
    username = Teller.Encryption.decrypt(key)
    enrollment = Teller.Repo.get_by(Teller.Schema.Enrollment, username: username)

    case enrollment do
      nil ->
        :invalid_key

      _ ->
        {:ok, enrollment.username}
    end

    {:ok, enrollment.username}
  end

  defp verify_api_key(_key) do
    :no_key
  end
end
