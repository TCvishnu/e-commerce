defmodule Server.Accounts.Validator do
  import Ecto.Changeset

  def validate_email(user_changeset, email) do
    email_regex = ~r/@gmail\.com$/

    validate_format(user_changeset, email, email_regex, message: "Invalid email format")
  end

  def validate_phone_number(user_changeset, phone_number) do
    phone_number_regex = ~r/^\d{10}$/
    validate_format(user_changeset, phone_number, phone_number_regex, message: "Phone number should be 10 digits")
  end

  def validate_password(user_changeset, password) do
    password_regex = ~r/^(?=.*[A-Z])(?=.*\d).{8,}$/
    validate_format(user_changeset, password, password_regex,
    message: "Password must be 8 characters long with minimum 1 uppercase letter and 1 digit")
  end

end
