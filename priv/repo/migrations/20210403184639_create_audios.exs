defmodule TabletopCast.Repo.Migrations.CreateAudios do
  use Ecto.Migration

  def change do
    create table(:audios) do
      add :name, :string
      add :src, :string
      add :volume, :integer
      add :loop, :boolean, default: false, null: false
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:audios, [:room_id])
  end
end
