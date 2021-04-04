defmodule TabletopCast.Repo.Migrations.CreateAudioNumField do
  use Ecto.Migration

  def change do
    alter table(:audios) do
      add :num, :integer
    end
  end
end
