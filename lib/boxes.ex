defmodule Boxes do
  @moduledoc """
  Documentation for Boxes.
  """

  @doc """
  Returns the id of the box.

  This function works applying the algorithm to find the id.
  It works as follows:
  Starting from the triangular configuration of the boxes we can notice
  that when we move orizontally (on the x axis) the next number is going
  to be the sum of the current position plus one, the same happens vertically (on the y axis).

  ## Parameters

    - `x`: Integer that represents the x coordinate
    - `y`: Integer that represents the y coordiate

  ## Example

      iex> Boxes.answer(2, 4)
      "12"

  """
  @spec answer(pos_integer, pos_integer) :: binary
  def answer(x, y) do
    find_partial_sum_on_wall(y)
    |> add_x_component(x, y)
    |> to_string()
  end

  @doc """
  Adds the x component to the partial sum on the y axis.

  It recursively sums the current value with the position value

  ## Parameters

    - `partial_sum`: Integer that represents the sum along the wall calculated in `find_partial_sum_on_wall/1`
    - `x`: Integer that represents the x coordinate
    - `y`: Integer that represents the y coordinate


  ## Example

      iex> Boxes.add_x_component(4, 3, 3)
      13
  """

  @spec add_x_component(pos_integer, pos_integer, pos_integer) :: pos_integer
  def add_x_component(partial_sum, 1, _y), do: partial_sum

  def add_x_component(partial_sum, x, y) do
    add_x_component(partial_sum + y + 1, x - 1, y + 1)
  end

  @doc """
  Finds the partial sum running vertically against the wall (y coordinate).

  Recursively sums the current value with the position value.

  ## Parameters

    - `y`: Integer that represents the y coordinate

  ## Example

      iex> Boxes.find_partial_sum_on_wall(4)
      7

  """
  @spec find_partial_sum_on_wall(pos_integer) :: pos_integer
  def find_partial_sum_on_wall(1), do: 1

  def find_partial_sum_on_wall(y) do
    find_partial_sum_on_wall(y - 1) + y - 1
  end

  @doc """
  Sums the x coordinate.

  Recursively sums the current value with the position value.

  This function is used by the function `reverse_answer/2`

  ## Parameters

    - `box_id`: Integer that represents the id of the box
    - `partial_sum`: Integer that was calculated in `find_partial_sum_on_wall`
    - `y`: Integer that represents the y coordinate

  ## Example

      iex> Boxes.find_x_component(8, 4, 3)
      2

  """
  @spec find_x_component(pos_integer, pos_integer, pos_integer) :: pos_integer
  def find_x_component(box_id, partial_sum, _y) when box_id == partial_sum, do: 1

  def find_x_component(box_id, partial_sum, y) do
    1 + find_x_component(box_id, partial_sum + y + 1, y + 1)
  end

  @doc """
  Finds the `x` coordinate starting from the `y` coordinate and the `box_id`

  ## Parameters

    - `y`: Integer that represents the y coordinate
    - `box_id`: Integer that represents the id of the box

  ## Example

      iex> Boxes.reverse_answer(100_000, 6_436_088_697)
      13457

  """
  @spec reverse_answer(pos_integer, pos_integer) :: pos_integer
  def reverse_answer(y, box_id) do
    partial_sum = find_partial_sum_on_wall(y)

    find_x_component(box_id, partial_sum, y)
  end
end
