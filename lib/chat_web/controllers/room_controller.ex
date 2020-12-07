defmodule ChatWeb.RoomController do
  use ChatWeb, :controller

  import Guardian.Plug

  def index(conn, _params) do
    user = Chat.Users.get_user!(current_resource(conn).id)
    ChatWeb.UserAuth.log_in_user(conn, user)
  end
end
