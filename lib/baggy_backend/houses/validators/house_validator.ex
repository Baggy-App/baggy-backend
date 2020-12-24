defmodule BaggyBackend.Houses.House.Validator do
  @moduledoc """
    Validator for House schema changeset.
  """  
  
  import Ecto.Changeset

  def validate_passcode(changeset) do
    passcode_validator = fn :passcode, passcode -> 
      if valid_passcode_format?(passcode) && valid_passcode_strength?(passcode) do
        []
      else
        [
          passcode: 
          "Must contain six non sequential nor repetitive numbers" <>
            " (e.g. 456789 or 765432 are sequential and 333333 is repetitive)."
        ] 
      end
    end
    validate_change(changeset, :passcode, passcode_validator)
  end

  defp valid_passcode_format?(passcode) do
    String.match?(passcode, ~r/[0-9]{6}/)
  end

  defp valid_passcode_strength?(passcode) do
    passcode_chars = String.graphemes passcode
    !(has_only_repeated_characters?(passcode_chars) ||
     has_only_sequential_digits?(passcode_chars))
  end

  defp has_only_repeated_characters?(string_chars) do
    length(Enum.uniq string_chars) == 1
  end

  defp has_only_sequential_digits?(string_chars) do
    reduce_result_position = 1
    elem(string_chars                                                                                
      |> Enum.with_index
      |> Enum.map_reduce(true, fn({num_str, index}, acc) ->
          current_num = String.to_integer num_str
          next_element = Enum.at string_chars, index + 1
          next_num = if next_element, do: String.to_integer next_element
          sequential_elements? = are_sequential_numbers? current_num, next_num
          {sequential_elements?, sequential_elements? && acc}
        end
      ), reduce_result_position)
  end
  
  defp are_sequential_numbers?(_first_num, nil), do: true
  defp are_sequential_numbers?(first_num, second_num) do
    first_num == (second_num + 1) || first_num == (second_num - 1)
  end
end
