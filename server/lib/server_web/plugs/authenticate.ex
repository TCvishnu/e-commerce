defmodule ServerWeb.Plug.Authenticate do
  import Plug.Conn
  require Logger
  alias ServerWeb.Auth.Guardian
  import Phoenix.Controller

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn = fetch_cookies(conn)
    case conn.cookies["authToken"] do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized attempt to fetch data"})
        |> halt()
      token ->
        case Guardian.decode_and_verify(token) do # correct token when decoded returns claims
          {:ok, claims} ->
            case Guardian.resource_from_claims(claims) do # retreive user info from claims
              {:ok, user} ->
                assign(conn, :current_user, user)
              {:error, _} -> # incase if user entry was deleted
                conn
                |> put_status(:unauthorized)
                |> json(%{error: "User not found"})
                |> halt()
            end
          {:error, _} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Invalid token"})
            |> halt()
        end
    end
  end
end
