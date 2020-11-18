defmodule ChatWeb.ApiAuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :chat,
    module: Chat.Guardian,
    error_handler: ChatWeb.ApiAuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
