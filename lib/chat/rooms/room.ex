defmodule Chat.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :description, :string
    field :name, :string
    belongs_to :user, Chat.Users.User
    has_many :messages, Chat.Rooms.Message

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name])
  end
end
