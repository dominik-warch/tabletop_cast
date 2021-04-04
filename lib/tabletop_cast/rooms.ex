defmodule TabletopCast.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias TabletopCast.Repo

  alias TabletopCast.Rooms.Room
  alias TabletopCast.Rooms.Audio

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  def get_room_with_audios_via_slug(slug) when is_binary(slug) do
    get_room(slug)
    |> Repo.preload([audios: (from a in Audio, order_by: a.id)])
  end

  def get_room_with_audios(id) do
    id
    |> get_room!()
    |> Repo.preload([audios: (from a in Audio, order_by: a.id)])
  end

  def get_room(slug) when is_binary(slug) do
    from(room in Room, where: room.slug == ^slug)
    |> Repo.one()
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  alias TabletopCast.Rooms.Audio

  @doc """
  Returns the list of audios.

  ## Examples

      iex> list_audios()
      [%Audio{}, ...]

  """
  def list_audios do
    Repo.all(Audio)
  end

  @doc """
  Gets a single audio.

  Raises `Ecto.NoResultsError` if the Audio does not exist.

  ## Examples

      iex> get_audio!(123)
      %Audio{}

      iex> get_audio!(456)
      ** (Ecto.NoResultsError)

  """
  def get_audio!(id), do: Repo.get!(Audio, id)

  @doc """
  Creates a audio.

  ## Examples

      iex> create_audio(%{field: value})
      {:ok, %Audio{}}

      iex> create_audio(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_audio(attrs \\ %{}) do
    %Audio{}
    |> Audio.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a audio.

  ## Examples

      iex> update_audio(audio, %{field: new_value})
      {:ok, %Audio{}}

      iex> update_audio(audio, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_audio(%Audio{} = audio, attrs) do
    audio
    |> Audio.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a audio.

  ## Examples

      iex> delete_audio(audio)
      {:ok, %Audio{}}

      iex> delete_audio(audio)
      {:error, %Ecto.Changeset{}}

  """
  def delete_audio(%Audio{} = audio) do
    Repo.delete(audio)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking audio changes.

  ## Examples

      iex> change_audio(audio)
      %Ecto.Changeset{data: %Audio{}}

  """
  def change_audio(%Audio{} = audio, attrs \\ %{}) do
    Audio.changeset(audio, attrs)
  end
end
