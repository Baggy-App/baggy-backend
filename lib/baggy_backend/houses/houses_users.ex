defmodule BaggyBackend.Houses.HousesUsers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "houses_users" do
    field :is_owner, :boolean, default: false
    field :house_id, :id
    field :user_uuid, :id

    timestamps()
  end

  @doc false
  def changeset(houses_users, attrs) do
    houses_users
    |> cast(attrs, [:is_owner])
    |> validate_required([:is_owner])
  end
end
