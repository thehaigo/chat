defmodule ChatWeb.RoomLive.Show do
  use ChatWeb, :live_view
  alias Chat.Rooms
  alias Chat.Rooms.Message
  alias ChatWeb.Presence

  @impl true
  def mount(%{"id" => id}, session, socket) do
    user = Chat.Users.get_user_by_session_token(session["user_token"])
    room = Rooms.get_room_with_messages!(id)
    changeset = Rooms.change_message(%Message{user_id: user.id, room_id: room.id})
    return_to = Routes.room_show_path(socket, :show, room)

    ChatWeb.Endpoint.subscribe("room:#{id}")
    Presence.track_presence(self(), "room:#{room.id}", user.id, %{ email: user.email, id: user.id})

    {:ok,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:room, room)
      |> assign(:messages, room.messages)
      |> assign(:return_to, return_to)
      |> assign(:changeset, changeset)
      |> assign(:user, user)
      |> assign(:users, Presence.list_presence("room:#{room.id}"))
    }
  end

  @impl true
  def handle_event("save", %{"message" => message_params}, socket) do
    case Rooms.create_message(message_params) do
      {:ok, _message} ->
        room = Rooms.get_room_with_messages!(socket.assigns.room.id)
        ChatWeb.Endpoint.broadcast!(
          "room:#{room.id}",
          "broadcast_message",
          %{ messages: room.messages}
        )
        {:noreply, socket }
      {:error, %Ecto.Changeset{} = changeset } ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info(%{event: "broadcast_message", payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{room: room}}) do
    {:noreply, assign(socket, users: Presence.list_presence("room:#{room.id}"))}
  end

  defp page_title(:show), do: "Show Room"
end
