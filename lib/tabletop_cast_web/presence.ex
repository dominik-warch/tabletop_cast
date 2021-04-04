defmodule TabletopCastWeb.Presence do
  use Phoenix.Presence,
    otp_app: :tabletop_cast,
    pubsub_server: TabletopCast.PubSub
end
