defmodule BaggyBackend.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :quantity, :integer
      add :min_price, :integer
      add :max_price, :integer
      add :done, :boolean, default: false, null: false
      add :product_list_id, references(:product_lists, on_delete: :delete_all)
      add :user_uuid, references(:users, on_delete: :nothing, type: :uuid, column: :uuid)
      add :product_category_id, references(:product_categories, on_delete: :delete_all)

      timestamps()
    end

    create index(:products, [:product_list_id])
    create index(:products, [:user_uuid])
    create index(:products, [:product_category_id])
  end
end
