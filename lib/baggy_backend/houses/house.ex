defmodule BaggyBackend.Houses.House do
  use Ecto.Schema
  import Ecto.Changeset

  schema "houses" do
    field :code, :string
    field :name, :string
    field :passcode, :integer

    timestamps()
  end

  @doc false
  def changeset(house, attrs) do
    house
    |> cast(attrs, [:name, :code, :passcode])
    |> validate_required([:name, :code, :passcode])
    |> unique_constraint(:code)
  end
end
