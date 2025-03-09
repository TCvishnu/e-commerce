defmodule Server.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Accounts.Validator
  import Bcrypt, only: [hash_pwd_salt: 1]

  schema "users" do
    field :username, :string
    field :email, :string
    field :phone_number, :string
    field :password, :string, virtual: true # to store password typed in by user, to be hashed
    field :hashed_password, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :phone_number, :password])
    |> validate_required([:username, :email, :phone_number, :password])
    |> unique_constraint(:phone_number)
    |> unique_constraint(:email)
    |> Validator.validate_email(:email)
    |> Validator.validate_phone_number(:phone_number)
    |> Validator.validate_password(:password)
    |> hash_password()
  end

  defp hash_password(user_changeset) do
    case get_change(user_changeset, :password) do
      nil -> user_changeset
      password ->
        user_changeset
        |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
        |> delete_change(:password)
    end
  end
end
