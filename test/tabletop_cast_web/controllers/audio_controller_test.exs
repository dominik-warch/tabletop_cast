defmodule TabletopCastWeb.AudioControllerTest do
  use TabletopCastWeb.ConnCase

  alias TabletopCast.Rooms

  @create_attrs %{loop: true, name: "some name", src: "some src", volume: 42}
  @update_attrs %{loop: false, name: "some updated name", src: "some updated src", volume: 43}
  @invalid_attrs %{loop: nil, name: nil, src: nil, volume: nil}

  def fixture(:audio) do
    {:ok, audio} = Rooms.create_audio(@create_attrs)
    audio
  end

  describe "index" do
    test "lists all audios", %{conn: conn} do
      conn = get(conn, Routes.audio_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Audios"
    end
  end

  describe "new audio" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.audio_path(conn, :new))
      assert html_response(conn, 200) =~ "New Audio"
    end
  end

  describe "create audio" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.audio_path(conn, :create), audio: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.audio_path(conn, :show, id)

      conn = get(conn, Routes.audio_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Audio"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.audio_path(conn, :create), audio: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Audio"
    end
  end

  describe "edit audio" do
    setup [:create_audio]

    test "renders form for editing chosen audio", %{conn: conn, audio: audio} do
      conn = get(conn, Routes.audio_path(conn, :edit, audio))
      assert html_response(conn, 200) =~ "Edit Audio"
    end
  end

  describe "update audio" do
    setup [:create_audio]

    test "redirects when data is valid", %{conn: conn, audio: audio} do
      conn = put(conn, Routes.audio_path(conn, :update, audio), audio: @update_attrs)
      assert redirected_to(conn) == Routes.audio_path(conn, :show, audio)

      conn = get(conn, Routes.audio_path(conn, :show, audio))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, audio: audio} do
      conn = put(conn, Routes.audio_path(conn, :update, audio), audio: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Audio"
    end
  end

  describe "delete audio" do
    setup [:create_audio]

    test "deletes chosen audio", %{conn: conn, audio: audio} do
      conn = delete(conn, Routes.audio_path(conn, :delete, audio))
      assert redirected_to(conn) == Routes.audio_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.audio_path(conn, :show, audio))
      end
    end
  end

  defp create_audio(_) do
    audio = fixture(:audio)
    %{audio: audio}
  end
end
