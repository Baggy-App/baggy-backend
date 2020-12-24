defmodule BaggyBackend.Repo.Migrations.CreateHouses do
  use Ecto.Migration

  def change do
    create table(:houses) do
      add :name, :string
      add :code, :string
      add :passcode, :string

      timestamps()
    end

    create unique_index(:houses, [:code])
  end
end
