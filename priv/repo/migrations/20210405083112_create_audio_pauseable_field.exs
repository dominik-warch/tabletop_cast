defmodule TabletopCast.Repo.Migrations.CreateAudioPauseableField do
  use Ecto.Migration

  def change do
    alter table(:audios) do
      add :pausable, :boolean, default: false, null: false
    end
  end
end
