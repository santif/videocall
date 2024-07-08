defmodule Videocall.Repo do
  use Ecto.Repo,
    otp_app: :videocall,
    adapter: Ecto.Adapters.Postgres
end
