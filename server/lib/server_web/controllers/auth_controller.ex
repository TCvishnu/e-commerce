defmodule ServerWeb.AuthController do
  use ServerWeb, :controller

  alias Server.Accounts
  alias ServerWeb.{UserJSON, ControllerUtils}
  alias ServerWeb.Auth.Guardian


  def register(conn, %{"email" => email, "password" => password}) do
    user_params = %{email: email, password: password}

    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_status(:created)
        |> json(%{message: "User registered successfully"})
      {:error, error_changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: ControllerUtils.handle_error_messages(error_changeset)})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:ok)
        |> put_resp_cookie("authToken", token, [
          http_only: true,
          secure: System.get_env("PHOENIX_ENV") == "production",
          max_age: 7 * 24 * 60 * 60,
          same_site: "None"
        ])
        |> json(%{message: "User Login successful", user: UserJSON.user(%{user: user})})
      {:error, error_msg} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: error_msg})
    end
  end
end
