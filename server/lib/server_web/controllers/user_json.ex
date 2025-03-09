defmodule ServerWeb.UserJSON do
  def user(%{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      phone_number: user.phone_number
    }
  end
end
