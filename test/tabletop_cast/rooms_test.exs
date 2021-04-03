defmodule TabletopCast.RoomsTest do
  use TabletopCast.DataCase

  alias TabletopCast.Rooms

  describe "rooms" do
    alias TabletopCast.Rooms.Room

    @valid_attrs %{slug: "some slug", title: "some title"}
    @update_attrs %{slug: "some updated slug", title: "some updated title"}
    @invalid_attrs %{slug: nil, title: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Rooms.create_room(@valid_attrs)
      assert room.slug == "some slug"
      assert room.title == "some title"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Rooms.update_room(room, @update_attrs)
      assert room.slug == "some updated slug"
      assert room.title == "some updated title"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end

  describe "audios" do
    alias TabletopCast.Rooms.Audio

    @valid_attrs %{loop: true, name: "some name", src: "some src", volume: 42}
    @update_attrs %{loop: false, name: "some updated name", src: "some updated src", volume: 43}
    @invalid_attrs %{loop: nil, name: nil, src: nil, volume: nil}

    def audio_fixture(attrs \\ %{}) do
      {:ok, audio} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_audio()

      audio
    end

    test "list_audios/0 returns all audios" do
      audio = audio_fixture()
      assert Rooms.list_audios() == [audio]
    end

    test "get_audio!/1 returns the audio with given id" do
      audio = audio_fixture()
      assert Rooms.get_audio!(audio.id) == audio
    end

    test "create_audio/1 with valid data creates a audio" do
      assert {:ok, %Audio{} = audio} = Rooms.create_audio(@valid_attrs)
      assert audio.loop == true
      assert audio.name == "some name"
      assert audio.src == "some src"
      assert audio.volume == 42
    end

    test "create_audio/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_audio(@invalid_attrs)
    end

    test "update_audio/2 with valid data updates the audio" do
      audio = audio_fixture()
      assert {:ok, %Audio{} = audio} = Rooms.update_audio(audio, @update_attrs)
      assert audio.loop == false
      assert audio.name == "some updated name"
      assert audio.src == "some updated src"
      assert audio.volume == 43
    end

    test "update_audio/2 with invalid data returns error changeset" do
      audio = audio_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_audio(audio, @invalid_attrs)
      assert audio == Rooms.get_audio!(audio.id)
    end

    test "delete_audio/1 deletes the audio" do
      audio = audio_fixture()
      assert {:ok, %Audio{}} = Rooms.delete_audio(audio)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_audio!(audio.id) end
    end

    test "change_audio/1 returns a audio changeset" do
      audio = audio_fixture()
      assert %Ecto.Changeset{} = Rooms.change_audio(audio)
    end
  end
end
