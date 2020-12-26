defmodule BaggyBackend.Repo.Migrations.CreateProductCategories do
  use Ecto.Migration

  def change do
    create table(:product_categories) do
      add :name, :string
      add :color, :string

      timestamps()
    end

    create index(:product_categories, [:name], unique: true)
  end
end
