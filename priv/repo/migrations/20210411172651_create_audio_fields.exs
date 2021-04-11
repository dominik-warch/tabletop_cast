defmodule TabletopCast.Repo.Migrations.CreateAudioFields do
  use Ecto.Migration

  def change do
    alter table(:audios) do
      add :music, :boolean, default: false
      add :ambience, :boolean, default: false
      add :fade, :boolean, default: false
    end
  end
end
