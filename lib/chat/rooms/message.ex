defmodule Chat.Rooms.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string

    belongs_to :user, Chat.Users.User
    belongs_to :room, Chat.Rooms.Room

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :user_id, :room_id])
    |> validate_required([:body, :user_id, :room_id])
  end
end
