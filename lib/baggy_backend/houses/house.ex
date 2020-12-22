defmodule BaggyBackend.Houses.House do
  use Ecto.Schema
  import Ecto.Changeset

  schema "houses" do
    field :code, :string
    field :name, :string
    field :passcode, :string

    timestamps()
  end

  @doc false
  def changeset(house, attrs) do
    house
    |> cast(attrs, [:name, :code, :passcode])
    |> validate_required([:name, :code, :passcode])
    |> validate_length(:code, min: 4, max: 8)
    |> validate_length(:passcode, is: 4)
    |> unique_constraint(:code)
  end
end
