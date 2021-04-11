defmodule TabletopCast.Repo.Migrations.ChangeDefaultAudioVolume do
  use Ecto.Migration

  def change do
    alter table(:audios) do
      modify :volume, :float, default: 0.5
    end
  end
end
