defmodule TabletopCast.Repo do
  use Ecto.Repo,
    otp_app: :tabletop_cast,
    adapter: Ecto.Adapters.Postgres
end
