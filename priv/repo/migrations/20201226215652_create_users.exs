defmodule BaggyBackend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :favorite_house_id, references(:houses, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:favorite_house_id])
  end
end
