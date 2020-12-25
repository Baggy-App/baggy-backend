defmodule BaggyBackend.Fixture do
  import BaggyBackend.Fixture.House

  def fixture(schema_name, attr_type, overwrite_attrs \\ %{}) do
    schema_fixture schema_name, attr_type, overwrite_attrs
  end

  def attrs(schema_name, attr_type) do
    schema_attrs schema_name, attr_type
  end
end
