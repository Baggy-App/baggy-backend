defmodule BaggyBackend.Repo.Migrations.UniqueConstraintOnUserHouseAssocCombination do
  use Ecto.Migration

  def change do
    create unique_index(:houses_users, [:house_id, :user_uuid], name: :index_user_on_house_in_houses_users)
  end
end
