defmodule BaggyBackend.Houses.HousesUsers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "houses_users" do
    field :is_owner, :boolean, default: false
    belongs_to :house, BaggyBackend.Houses.House
    belongs_to :user, BaggyBackend.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(houses_users, attrs) do
    houses_users
    |> cast(attrs, [:is_owner, :house_id, :user_uuid])
    |> validate_required([:is_owner, :house_id, :user_uuid])
    |> foreign_key_constraint(:house_id)
    |> foreign_key_constraint(:user_uuid)
  end
end
