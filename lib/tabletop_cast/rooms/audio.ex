defmodule TabletopCast.Rooms.Audio do
  use Ecto.Schema
  import Ecto.Changeset

  alias TabletopCast.Rooms.Room

  schema "audios" do
    field :loop, :boolean, default: false
    field :name, :string, default: ""
    field :src, :string
    field :volume, :integer
    belongs_to(:room, Room)

    timestamps()
  end

  @doc false
  def changeset(audio, attrs) do
    audio
    |> cast(attrs, [:name, :src, :volume, :loop, :room_id])
    |> validate_required([:room_id])
    |> assoc_constraint(:room)
  end
end
