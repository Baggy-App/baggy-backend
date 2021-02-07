defmodule BaggyBackendWeb.ParamsHandler do
  @moduledoc """
  Module with methods to easily filter and validate parameters
  """

  def filter_params(params, desired_params) do
    case true_or_error = validate_required_params(params, desired_params) do
      true ->
        Map.take(params, desired_params)

      _ ->
        true_or_error
    end
  end

  def validate_required_params(params, required_params) do
    if required_params
       |> Enum.all?(&Map.has_key?(params, &1)),
       do: true,
       else:
         {:error, :unprocessable_entity,
         "The required params are '#{Enum.join(required_params, "', '")}'."}
  end
end
