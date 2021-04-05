defmodule TabletopCastWeb.Room.ShowLive do
  @moduledoc """
  A LiveView for creating and joing audio rooms.
  """

  use TabletopCastWeb, :live_view

  alias TabletopCast.ConnectedUser
  alias TabletopCastWeb.Presence
  alias TabletopCast.Rooms
  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    user = create_connected_user()
    Phoenix.PubSub.subscribe(TabletopCast.PubSub, "room:" <> slug)
    {:ok, _} = Presence.track(self(), "room:" <> slug, user.uuid, %{})

    case Rooms.get_room_with_audios_via_slug(slug) do
      nil ->
        {:ok,
          socket
          |> put_flash(:error, "Dieser Raum existiert nicht.")
          |> push_redirect(to: Routes.new_path(socket, :new))
        }
      room ->
        {:ok,
          socket
          |> assign(:room, room)
          |> assign(:user, user)
          |> assign(:slug, slug)
          |> assign(:connected_users, [])
        }
      end
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply,
      socket
      |> assign(:connected_users, list_present(socket))
    }
  end

  def handle_info({:audio_played, message}, socket) do
    {:noreply, push_event(socket, "play_audio", %{audio_id: message})}
  end

  def handle_info({:audio_stopped, message}, socket) do
    {:noreply, push_event(socket, "stop_audio", %{audio_id: message})}
  end

  def handle_info({:audio_paused, message}, socket) do
    {:noreply, push_event(socket, "pause_audio", %{audio_id: message})}
  end

  def handle_info({:volume_changed, audio_id, volume}, socket) do
    {volume, _} = Float.parse(volume)
    {:noreply, push_event(socket, "change_volume", %{audio_id: audio_id, volume: volume})}
  end

  @impl true
  def handle_event("PlayAudio", %{"id" => id}, socket) do
    audio_id = String.slice(id, 5..-1)
    message = {:audio_played, audio_id}
    Phoenix.PubSub.broadcast(TabletopCast.PubSub, "room:" <> socket.assigns.slug, message)
    {:noreply, push_event(socket, "play_audio", %{audio_id: audio_id})}
  end

  def handle_event("StopAudio", %{"id" => id}, socket) do
    audio_id = String.slice(id, 5..-1)
    message = {:audio_stopped, audio_id}
    Phoenix.PubSub.broadcast(TabletopCast.PubSub, "room:" <> socket.assigns.slug, message)
    {:noreply, push_event(socket, "stop_audio", %{audio_id: audio_id})}
  end

  def handle_event("PauseAudio", %{"id" => id}, socket) do
    audio_id = String.slice(id, 6..-1)
    message = {:audio_paused, audio_id}
    Phoenix.PubSub.broadcast(TabletopCast.PubSub, "room:" <> socket.assigns.slug, message)
    {:noreply, push_event(socket, "pause_audio", %{audio_id: audio_id})}
  end

  def handle_event("ChangeVolume", %{"_target" => [id|_]} = params, socket) do
    volume = params[id]
    message = {:volume_changed, id, volume}
    Phoenix.PubSub.broadcast(TabletopCast.PubSub, "room:" <> socket.assigns.slug, message)
    {:noreply, push_event(socket, "change_volume", %{})}
  end

  defp list_present(socket) do
    Presence.list("room:" <> socket.assigns.slug)
    |> Enum.map(fn {k, _} -> k end)
  end

  defp create_connected_user do
    %ConnectedUser{uuid: UUID.uuid4()}
  end
end
