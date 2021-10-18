defmodule TabletopCastWeb.AudioController do
  use TabletopCastWeb, :controller

  alias TabletopCast.Rooms

  def index(conn, _params) do
    audios = Rooms.list_audios()
    render(conn, "index.html", audios: audios)
  end

  def show(conn, %{"id" => id}) do
    audio = Rooms.get_audio!(id)
    render(conn, "show.html", audio: audio)
  end

  def edit(conn, %{"id" => id, "room_id" => room_id}) do
    room = Rooms.get_room!(room_id)
    audio = Rooms.get_audio!(id)
    changeset = Rooms.change_audio(audio)
    render(conn, "edit.html", audio: audio, room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room_id" => room_id, "audio" => audio_params}) do
    room = Rooms.get_room!(room_id)
    audio = Rooms.get_audio!(id)

    audio_params =
      if upload = audio_params["audio_file"] do
        file_extension = Path.extname(upload.filename)
        File.cp(upload.path, "/home/dominik/media/#{room.id}/audio-#{audio.num}#{file_extension}")
        Map.put(audio_params, "src", "https://tabletopcast.de/media/#{room.id}/audio-#{audio.num}#{file_extension}")
      else
        audio_params
      end

    case Rooms.update_audio(audio, audio_params) do
      {:ok, _audio} ->
        conn
        |> put_flash(:info, "Audiofeld erfolgreich aktualisiert.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", audio: audio, changeset: changeset)
    end
  end
end
