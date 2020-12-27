defmodule BaggyBackend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @derive {Phoenix.Param, key: :uuid}

  schema "users" do
    field :name, :string
    field :favorite_house_id, :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :favorite_house_id])
    |> validate_required([:name])
  end
end
