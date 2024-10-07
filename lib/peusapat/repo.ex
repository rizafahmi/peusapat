defmodule Peusapat.Repo do
  use Ecto.Repo,
    otp_app: :peusapat,
    adapter: Ecto.Adapters.Postgres
end
