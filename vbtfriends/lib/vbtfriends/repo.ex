defmodule Vbtfriends.Repo do
  use Ecto.Repo,
    otp_app: :vbtfriends,
    adapter: Ecto.Adapters.Postgres
end
