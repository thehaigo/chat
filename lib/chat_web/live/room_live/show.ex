defmodule ChatWeb.RoomLive.Show do
  use ChatWeb, :live_view
  alias Chat.Rooms
  alias Chat.Rooms.Message

  @impl true
  def mount(%{"id" => id}, session, socket) do
    user = Chat.Users.get_user_by_session_token(session["user_token"])
    room = Rooms.get_room_with_messages!(id)
    changeset = Rooms.change_message(%Message{user_id: user.id, room_id: room.id})
    return_to = Routes.room_show_path(socket, :show, room)
    {:ok,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:room, room)
      |> assign(:messages, room.messages)
      |> assign(:return_to, return_to)
      |> assign(:changeset, changeset)
      |> assign(:user, user)
    }
  end

  @impl true
  def handle_event("save", %{"message" => message_params}, socket)
  do
    case Rooms.create_message(message_params) do
      {:ok, _message} ->
        {:noreply, socket
          |> put_flash(:info, "Message created successfully")
          |> push_redirect(to: socket.assigns.return_to)
        }
      {:error, %Ecto.Changeset{} = changeset } ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp page_title(:show), do: "Show Room"
end
