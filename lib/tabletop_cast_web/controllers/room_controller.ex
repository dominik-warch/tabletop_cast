defmodule TabletopCastWeb.RoomController do
  use TabletopCastWeb, :controller

  alias TabletopCast.Rooms
  alias TabletopCast.Rooms.Room

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Rooms.change_room(%Room{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    case Rooms.create_room(room_params) do
      {:ok, room} ->
        Enum.each(1..21, fn number ->
          Rooms.create_audio(%{room_id: room.id, num: number})
        end)
        File.mkdir("/home/deploy/media/#{room.id}")

        conn
        |> put_flash(:info, "Raum erfolgreich angelegt.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Rooms.get_room_with_audios(id)
    render(conn, "show.html", room: room)
  end

  def edit(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    changeset = Rooms.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Rooms.get_room!(id)

    case Rooms.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Raum erfolgreich aktualisiert.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    {:ok, _room} = Rooms.delete_room(room)
    File.rm_rf("/home/deploy/media/#{room.slug}")

    conn
    |> put_flash(:info, "Raum erfolgreich gelöscht.")
    |> redirect(to: Routes.room_path(conn, :index))
  end
end
