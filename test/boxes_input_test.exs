defmodule BoxesInputTest do
  use ExUnit.Case

  test "calculate_ids/1" do
    assert BoxesInput.calculate_ids("test/files/simple_input.txt") ==
             %{{2, 2} => "5"}

    assert BoxesInput.calculate_ids("test/files/multiple_input.txt") ==
             %{
               {2, 2} => "5",
               {2, 4} => "12",
               {4, 1} => "10",
               {4, 2} => "14",
               {612, 231} => "354673"
             }

    assert BoxesInput.calculate_ids("test/files/mutliple_input_after_terminator.txt") == %{
             {2, 2} => "5",
             {2, 4} => "12",
             {4, 1} => "10",
             {4, 2} => "14",
             {612, 231} => "354673"
           }

    assert BoxesInput.calculate_ids("test/files/non_existent_file.txt") == {:error, :enoent}
    assert BoxesInput.calculate_ids("test/files/only_terminator.txt") == {:error, "Empty file"}
    assert BoxesInput.calculate_ids("test/files/empty_file.txt") == {:error, "Empty file"}

    assert BoxesInput.calculate_ids("test/files/no_termination.txt") ==
             {:error, "The file does not have a proper termination"}

    assert BoxesInput.calculate_ids("test/files/odd_number_of_input.txt") ==
             {:error, "The file has an invalid length"}

    assert BoxesInput.calculate_ids("test/files/invalid_format_input.txt") ==
             {:error, "One or more elements in the input file is not an allowed positive integer"}
  end

  test "convert_list/1" do
    assert BoxesInput.convert_list(["1", "2", "0"]) == {:ok, [1, 2, 0]}

    assert BoxesInput.convert_list(["1", "2", "100001", "0"]) ==
             {:error, "One or more elements in the input file is not an allowed positive integer"}

    assert BoxesInput.convert_list(["1", "2.3", "0"]) ==
             {:error, "One or more elements in the input file is not an allowed positive integer"}

    assert BoxesInput.convert_list(["1", "two", "0"]) ==
             {:error, "One or more elements in the input file is not an allowed positive integer"}

    assert BoxesInput.convert_list(["1.56", "2", "0"]) ==
             {:error, "One or more elements in the input file is not an allowed positive integer"}

    assert BoxesInput.convert_list(["1", "2", "-3", "0"]) ==
             {:error, "One or more elements in the input file is not an allowed positive integer"}
  end

  test "cut_list/1" do
    assert BoxesInput.cut_list(["1", "2", "0"]) == ["1", "2"]
    assert BoxesInput.cut_list(["1", "2", "0", "4"]) == ["1", "2"]
    assert BoxesInput.cut_list(["1", "2", "0", "4", "5", "0"]) == ["1", "2"]
  end

  test "list_terminates?/1" do
    assert BoxesInput.list_terminates?(["0"]) == true
    assert BoxesInput.list_terminates?(["1", "2", "3"]) == false
    assert BoxesInput.list_terminates?([]) == false
    assert BoxesInput.list_terminates?(["1", "2", "0"]) == true
  end

  test "is_valid_length?/1" do
    assert BoxesInput.is_valid_length?([]) == false
    assert BoxesInput.is_valid_length?(["0"]) == false
    assert BoxesInput.is_valid_length?(["1", "54", "3"]) == false
    assert BoxesInput.is_valid_length?(["1", "2"]) == true
    assert BoxesInput.is_valid_length?(["1", "2", "3", "4"]) == true
  end

  test "validate_file/1" do
    assert BoxesInput.validate_file(["1", "2", "3"]) ==
             {:error, "The file does not have a proper termination"}

    assert BoxesInput.validate_file(["1", "2", "3", "0"]) ==
             {:error, "The file has an invalid length"}

    assert BoxesInput.validate_file(["1", "2.6", "3", "4", "0"]) ==
             {:error, "One or more elements in the input file is not an allowed positive integer"}

    assert BoxesInput.validate_file(["1", "2", "3", "4", "0"]) ==
             {:ok, [1, 2, 3, 4]}

    assert BoxesInput.validate_file(["1", "2", "3", "4", "0", "4", "3"]) ==
             {:ok, [1, 2, 3, 4]}
  end
end
