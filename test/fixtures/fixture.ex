defmodule BaggyBackend.Fixture do
  @moduledoc "Fixture Modelulo"
  import BaggyBackend.Fixture.House
  import BaggyBackend.Fixture.Category
  import BaggyBackend.Fixture.User

  def fixture(schema_name, attr_type, overwrite_attrs \\ %{}) do
    case schema_name do
      :house -> house_fixture schema_name, attr_type, overwrite_attrs
      :category -> category_fixture schema_name, attr_type, overwrite_attrs
      :user -> user_fixture schema_name, attr_type, overwrite_attrs
    end
  end

  def attrs(schema_name, attr_type) do
    case schema_name do
      :house -> house_attrs schema_name, attr_type
      :category -> category_attrs schema_name, attr_type
      :user -> user_attrs schema_name, attr_type
    end
  end

end
