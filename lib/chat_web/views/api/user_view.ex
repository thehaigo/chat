defmodule ChatWeb.Api.UserView do
  use ChatWeb, :view

  def render("jwt.json", %{token: token}) do
    %{ token: token }
  end
end
