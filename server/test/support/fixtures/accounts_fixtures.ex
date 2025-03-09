defmodule Server.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Server.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user phone_number.
  """
  def unique_user_phone_number, do: "some phone_number#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        hashed_password: "some hashed_password",
        phone_number: unique_user_phone_number(),
        username: "some username"
      })
      |> Server.Accounts.create_user()

    user
  end
end
