defmodule BaggyBackend.Fixture do
  @moduledoc "Fixture Modelulo"
  import BaggyBackend.Fixture.House
  import BaggyBackend.Fixture.Category
  import BaggyBackend.Fixture.User
  import BaggyBackend.Fixture.List

  def fixture(schema_name, attr_type, overwrite_attrs \\ %{}) do
    case schema_name do
      :house -> house_fixture(attr_type, overwrite_attrs)
      :category -> category_fixture(attr_type, overwrite_attrs)
      :user -> user_fixture(attr_type, overwrite_attrs)
      :list -> list_fixture(attr_type, overwrite_attrs)
    end
  end

  def attrs(schema_name, attr_type) do
    case schema_name do
      :house -> house_attrs(attr_type)
      :category -> category_attrs(attr_type)
      :user -> user_attrs(attr_type)
      :list -> list_attrs(attr_type)
    end
  end
end
