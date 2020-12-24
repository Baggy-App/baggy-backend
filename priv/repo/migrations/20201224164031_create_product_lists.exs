defmodule BaggyBackend.Repo.Migrations.CreateProductLists do
  use Ecto.Migration

  def change do
    create table(:product_lists) do
      add :name, :string
      add :house_id, references(:houses, on_delete: :delete_all)

      timestamps()
    end

    create index(:product_lists, [:house_id])
  end
end
