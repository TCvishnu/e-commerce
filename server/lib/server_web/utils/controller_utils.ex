defmodule ServerWeb.ControllerUtils do

  def handle_error_messages(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
