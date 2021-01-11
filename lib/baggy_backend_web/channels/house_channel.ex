defmodule BaggyBackendWeb.HouseChannel do
  @moduledoc """
  Channel for house-related connections
  """
  use BaggyBackendWeb, :channel

  alias BaggyBackend.{Houses, Products, Products.ProductList, Products.Product}

  alias BaggyBackendWeb.ParamsHandler, as: Params

  @product_list_update_attrs ["name"]

  @product_list_create_attrs ["name", "house_id"]

  @product_create_attrs [
    "name",
    "description",
    "quantity",
    "min_price",
    "max_price",
    "done",
    "product_list_id",
    "product_category_id",
    "user_uuid"
  ]

  @product_update_attrs [
    "name",
    "description",
    "quantity",
    "min_price",
    "max_price",
    "done"
  ]

  @impl true
  def join("house:" <> house_id, payload, socket) do
    with true <- authorized_user?(payload),
         {:ok, %Houses.House{} = house} <- get_house(house_id, :product_lists),
         %Houses.House{product_lists: product_lists} <- house do
      socket = assign(socket, :product_lists, product_lists)
      response = %{house: house, product_lists: product_lists}
      {:ok, response, socket}
    else
      {:error, error} -> {:reply, {:error, error}, socket}
    end
  end

  @impl true
  def handle_in("product_list:create", %{"product_list" => params}, socket) do
    params = Params.filter_params(params, @product_list_create_attrs)

    case Products.create_product_list(params) do
      {:ok, product_list} ->
        broadcast(socket, "product_list:created", %{product_list: product_list})
        {:noreply, socket}

      {:error, changeset} ->
        {:reply, {:error, changeset.errors}, socket}
    end
  end

  @impl true
  def handle_in("product_list:update", %{"id" => id, "product_list" => params}, socket) do
    params = Map.take(params, @product_list_update_attrs)

    with {:ok, %ProductList{} = product_list} <- get_product_list(id),
         {:ok, %ProductList{} = product_list} <-
           Products.update_product_list(product_list, params) do
      broadcast(socket, "product_list:update", %{product_list: product_list})
      {:noreply, socket}
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:reply, {:error, changeset.errors}, socket}
      {:error, error} -> {:reply, {:error, error}, socket}
    end
  end

  @impl true
  def handle_in(
        "product_list:product:create",
        %{"product_list_id" => product_list_id, "product" => params},
        socket
      ) do
    params = Map.take(params, @product_create_attrs)

    with {:ok, %ProductList{} = product_list} <- get_product_list(product_list_id),
         {:ok, %Product{} = product} <-
           Products.create_product(params) do
      broadcast(socket, "product_list:product:create", %{
        product_list_id: product_list.id,
        product: product
      })

      {:noreply, socket}
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:reply, {:error, changeset.errors}, socket}
      {:error, error} -> {:reply, {:error, error}, socket}
    end
  end

  @impl true
  def handle_in(
        "product_list:product:update",
        %{"id" => id, "product" => params},
        socket
      ) do
    params = Map.take(params, @product_update_attrs)

    with {:ok, %Product{} = product} <- get_product(id),
         {:ok, %Product{} = product} <- Products.update_product(product, params) do
      broadcast(socket, "product_list:product:update", %{
        product_list_id: product.product_list_id,
        product: product
      })

      {:noreply, socket}
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:reply, {:error, changeset.errors}, socket}
      {:error, error} -> {:reply, {:error, error}, socket}
    end
  end

  @impl true
  def handle_in(
        "product_list:product:delete",
        %{"id" => id},
        socket
      ) do
    with {:ok, %Product{} = product} <- get_product(id),
         {:ok, %Product{}} <- Products.delete_product(product) do
      broadcast(socket, "product_list:product:delete", %{
        product_list_id: product.product_list_id,
        product_id: id
      })

      {:noreply, socket}
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:reply, {:error, changeset.errors}, socket}
      {:error, error} -> {:reply, {:error, error}, socket}
    end
  end

  defp authorized_user?(_payload) do
    # Check correct passcode and search for houses_users association
    if true, do: true, else: {:error, "unauthorized"}
  end

  defp get_house(id, assocs) do
    try do
      {:ok, Houses.get_house!(id, assocs)}
    rescue
      _error in Ecto.NoResultsError -> {:error, "Record with id #{id} could not be found"}
    end
  end

  defp get_product_list(id) do
    try do
      {:ok, Products.get_product_list!(id)}
    rescue
      _error in Ecto.NoResultsError -> {:error, "Record with id #{id} could not be found"}
    end
  end

  defp get_product(id) do
    try do
      {:ok, Products.get_product!(id)}
    rescue
      _error in Ecto.NoResultsError -> {:error, "Record with id #{id} could not be found"}
    end
  end
end
