defmodule BaggyBackend.Houses.House.Validator do
  import Ecto.Changeset

  def validate_passcode_strength(changeset) do
    passcode_strength_validator = fn :passcode, passcode -> 
      passcode_chars = String.graphemes passcode
      valid_passcode? = !(has_only_repeated_characters?(passcode_chars) || has_only_sequential_digits?(passcode_chars))
      if valid_passcode? do
        []
      else
        [passcode: "Has to be secure."] 
      end
    end
    validate_change(changeset, :passcode, passcode_strength_validator)
  end

  defp has_only_repeated_characters?(string_chars) do
    length(Enum.uniq string_chars) == 1
  end

  defp has_only_sequential_digits?(string_chars) do
    elem(string_chars                                                                                
      |> Enum.with_index
      |> Enum.map_reduce(true ,fn({num_str, index}, acc) ->
          current_num = String.to_integer num_str
          next_element = Enum.at string_chars, index + 1
          next_num = if next_element, do: String.to_integer(next_element)
          elements_are_sequential = are_sequential_numbers? current_num, next_num
          { elements_are_sequential, elements_are_sequential && acc }
        end
      ), 1)
  end
  
  defp are_sequential_numbers?(_first_num, nil), do: true
  defp are_sequential_numbers?(first_num, second_num) do
    first_num == (second_num + 1) || first_num == (second_num - 1)
  end
end
