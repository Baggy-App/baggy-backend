defmodule BaggyBackendWeb.HouseChannel do
  @moduledoc """
  Channel for house-related connections
  """
  use BaggyBackendWeb, :channel

  alias BaggyBackend.{Houses, Products, Products.ProductList}

  @product_list_allowed_attrs ["name"]

  @impl true
  def join("house:" <> house_id, payload, socket) do
    if authorized?(payload) do
      %{lists: lists} = Houses.get_house!(house_id, :lists)
      socket = assign(socket, :lists, lists)
      response = %{lists: lists}
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
  def handle_in("product_list:update", %{"id" => id, "product_list" => params}, socket) do
    params = Map.take(params, @product_list_allowed_attrs)

    with %ProductList{} = product_list <- Products.get_product_list!(id),
         {:ok, %ProductList{} = product_list} <- update_product_list(product_list, params) do
      broadcast(socket, "product_list:update", %{product_list: product_list})
      {:noreply, socket}
    else
      error -> {:reply, error, socket}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp update_product_list(product_list, params) do
    case Products.update_product_list(product_list, params) do
      {:ok, %ProductList{} = product_list} -> {:ok, product_list}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
