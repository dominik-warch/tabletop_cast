defmodule TabletopCastWeb.Room.NewLive do
  use TabletopCastWeb, :live_view

  alias TabletopCast.Repo
  alias TabletopCast.Rooms.Room

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Erstelle neuen Raum</h1>
    <div>
      <%= form_for @changeset, "#", [phx_change: "validate", phx_submit: "save"], fn f -> %>
        <%= text_input f, :title, placeholder: "Titel" %>
        <%= error_tag f, :title %>
        <%= text_input f, :slug, placeholder: "Kurzname" %>
        <%= error_tag f, :slug %>
        <%= submit "Speichern" %>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> put_changeset()
    }
  end

  @impl true
  def handle_event("validate", %{"room" => room_params}, socket) do
    {:noreply,
      socket
      |> put_changeset(room_params)
    }
  end

  def handle_event("save", _, %{assigns: %{changeset: changeset}} = socket) do
    case Repo.insert(changeset) do
      {:ok, room} ->
        {:noreply,
          socket
          |> push_redirect(to: Routes.show_path(socket, :show, room.slug))
        }
      {:error, changeset} ->
        {:noreply,
          socket
          |> assign(:changeset, changeset)
          |> put_flash(:error, "Raum konnte nicht gespeichert werden.")
        }
    end
  end

  defp put_changeset(socket, params \\ %{}) do
    socket
    |> assign(:changeset, Room.changeset(%Room{}, params))
  end
end
