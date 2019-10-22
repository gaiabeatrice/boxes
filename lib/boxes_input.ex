defmodule BoxesInput do
  @moduledoc """
  Documentation for BoxesInput.

  This module is useful to produce the `box_id` for each coordinate pair, specified in a txt file.
  """

  @doc """
  Calculates the `box_id`, given a list of coordinate in a txt file that terminates with the character `0`.

  The coordinates have to appear in the text file in the following way:

  ```
  coordinate_x_1
  coordinate_y_1
  coordinate_x_2
  coordinate_y_2
  ...
  0
  ```

  For example:
  ```
  2
  2
  4
  1
  0
  ```


  It returns a map that has the coordinates as a tuple as a key, and the `box_id` as the value.
  ## Parameters
    - `file_path`: the path of the file
  """
  @spec calculate_ids(binary) :: map() | tuple()
  def calculate_ids(file_path) do
    with {:file_read, {:ok, file}} <- {:file_read, File.read(file_path)},
         input_list <- String.split(file, "\n"),
         {:ok, validated_list} <-
           input_list |> Enum.reject(fn x -> x == "" end) |> validate_file() do
      Enum.chunk_every(validated_list, 2)
      |> Enum.map(fn [x, y] ->
        {{x, y}, Boxes.answer(x, y)}
      end)
      |> Enum.into(%{})
    else
      {:file_read, {:error, error}} -> {:error, error}
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Validates whether the list terminates correctly.

  A list terminates correctly if it contains the character `0`.

  ## Parameters
    - `input_list`: a list of (binary) coordinates

  ## Example

      iex> BoxesInput.list_terminates?(["1", "2", "0"])
      true

  """
  @spec list_terminates?(list(binary)) :: boolean
  def list_terminates?(input_list) do
    Enum.any?(input_list, fn element -> element == "0" end)
  end

  @doc """
  Removes all the elements of the list including and after the character `0`.

  ## Parameters
    - `input_list`: a list of (binary) coordinates

  ## Example

      iex> BoxesInput.cut_list(["1", "2", "0", "4", "5", "0"])
      ["1", "2"]

  """
  @spec cut_list([binary]) :: [binary]
  def cut_list(input_list) do
    index =
      Enum.find_index(input_list, fn element ->
        element == "0"
      end)

    Enum.slice(input_list, 0..(index - 1))
  end

  @doc """
  Validates the length of the list.

  A list is considerate valid if it is non empty and the number of elements is even.

  ## Parameters
    - `input_list`: a list of (binary) coordinates

  ## Example

      iex> BoxesInput.is_valid_length?(["1", "2", "3", "4"])
      true

  """
  @spec is_valid_length?([binary]) :: boolean
  def is_valid_length?([]), do: false

  def is_valid_length?(input_list) when length(input_list) |> rem(2) == 0, do: true

  def is_valid_length?(_input_list), do: false

  @doc """
  Converts the list of binaries to a list of integers.

  All the elements that are not positive numbers are not accepted.
  Each value must be no greater that 100,000.

  ## Parameters
    - `input_list`: a list of (binary) coordinates

  ## Example

      iex> BoxesInput.convert_list(["1", "2", "0"])
      {:ok, [1, 2, 0]}

  """
  @spec convert_list([binary]) :: :error | {:ok, [pos_integer]}
  def convert_list(input_list) do
    converted_list =
      Enum.map(input_list, fn element ->
        case Integer.parse(element) do
          {value, ""} ->
            case value < 0 or value > 100_000 do
              true ->
                :error

              false ->
                value
            end

          _ ->
            :error
        end
      end)

    case Enum.any?(converted_list, fn element ->
           element == :error
         end) do
      true ->
        {:error, "One or more elements in the input file is not an allowed positive integer"}

      false ->
        {:ok, converted_list}
    end
  end

  @doc """
  Validates the list obtained reading from the file.

  If the list is valid it is returned in a tuple with the atom `:ok`.

  ## Parameters
    - `input_list`: a list of (binary) coordinates

  ## Example

      iex> BoxesInput.validate_file(["1", "2", "3", "4", "0"])
      {:ok, [1, 2, 3, 4]}

  """
  @spec validate_file([binary]) :: {:error, binary} | {:ok, [pos_integer]}
  def validate_file(["0"]), do: {:error, "Empty file"}

  def validate_file([]), do: {:error, "Empty file"}

  def validate_file(input_list) do
    with {:termination_validation, true} <-
           {:termination_validation, list_terminates?(input_list)},
         cut_list <- cut_list(input_list),
         {:length_validation, true} <- {:length_validation, is_valid_length?(cut_list)},
         {:conversion, {:ok, converted_list}} <- {:conversion, convert_list(cut_list)} do
      {:ok, converted_list}
    else
      {:termination_validation, false} ->
        {:error, "The file does not have a proper termination"}

      {:length_validation, false} ->
        {:error, "The file has an invalid length"}

      {:conversion, {:error, message}} ->
        {:error, message}
    end
  end
end
