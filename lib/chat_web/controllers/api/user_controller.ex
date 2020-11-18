defmodule ChatWeb.Api.UserController do
  use ChatWeb, :controller

  alias Chat.Users
  alias Chat.Users.User
  alias Chat.Guardian

  action_fallback ChatWeb.FallbackController

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user } <- Users.register_user(user_params) do
      { :ok, token, _claims } = Guardian.encode_and_sign(user)
      conn |> render("jwt.json", token: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password }) do
    with { :ok, token, _claims } <- Users.token_sign_in(email, password) do
      conn |> render("jwt.json", token: token)
    end
  end
end
