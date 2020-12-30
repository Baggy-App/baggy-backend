defmodule BaggyBackend.Repo.Migrations.CreateHousesUsers do
  use Ecto.Migration

  def change do
    create table(:houses_users) do
      add :is_owner, :boolean, default: false, null: false
      add :house_id, references(:houses, on_delete: :nothing)
      add :user_uuid, references(:users, on_delete: :nothing, type: :uuid, column: :uuid)

      timestamps()
    end

    create index(:houses_users, [:house_id])
    create index(:houses_users, [:user_uuid])
  end
end
