defmodule TabletopCast.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias TabletopCast.Rooms.Audio

  schema "rooms" do
    field :slug, :string
    field :title, :string
    has_many :audios, Audio

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:title, :slug])
    |> validate_required([:title, :slug])
    |> format_slug()
    |> unique_constraint(:slug)
  end

  defp format_slug(%Ecto.Changeset{changes: %{slug: _}} = changeset) do
    changeset
    |> update_change(:slug, fn slug ->
      slug
      |> String.downcase()
      |> String.replace(" ", "-")
    end)
  end

  defp format_slug(changeset), do: changeset
end
