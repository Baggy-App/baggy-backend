defmodule BaggyBackendWeb.HouseChannel do
  @moduledoc """
  Channel for house-related connections
  """
  use BaggyBackendWeb, :channel

  alias BaggyBackend.{Houses, Products, Products.ProductList}

  alias BaggyBackendWeb.ParamsHandler, as: Params

  @product_list_update_attrs ["name"]

  @product_list_create_attrs ["name", "house_id"]

  @impl true
  def join("house:" <> house_id, payload, socket) do
    if authorized?(payload) do
      %{product_lists: product_lists} = Houses.get_house!(house_id, :product_lists)
      socket = assign(socket, :product_lists, product_lists)
      response = %{product_lists: product_lists}
      {:ok, response, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (house:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in("product_list:create", %{"product_list" => params}, socket) do
    params = Params.filter_params(params, @product_list_create_attrs)

    case create_product_list(params) do
      {:ok, product_list} ->
        broadcast(socket, "product_list:created", %{product_list: product_list})
        {:noreply, socket}

      {:error, error} ->
        {:reply, {:error, error}, socket}
    end
  end

  @impl true
  def handle_in("product_list:update", %{"id" => id, "product_list" => params}, socket) do
    params = Map.take(params, @product_list_update_attrs)

    with {:ok, %ProductList{} = product_list} <- get_product_list(id),
         {:ok, %ProductList{} = product_list} <- update_product_list(product_list, params) do
      broadcast(socket, "product_list:updated", %{product_list: product_list})
      {:noreply, socket}
    else
      {:error, error} -> {:reply, {:error, error}, socket}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp create_product_list(params) do
    case Products.create_product_list(params) do
      {:ok, %ProductList{} = product_list} -> {:ok, product_list}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end

  defp get_product_list(id) do
    try do
      {:ok, Products.get_product_list!(id)}
    rescue
      _error in Ecto.NoResultsError -> {:error, "Record with id #{id} could not be found"}
    end
  end

  defp update_product_list(product_list, params) do
    case Products.update_product_list(product_list, params) do
      {:ok, %ProductList{} = product_list} -> {:ok, product_list}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
