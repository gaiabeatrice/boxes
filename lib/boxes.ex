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

  Note: The x axis sum starts from 2, while the one on the y axis starts from 1.

  ## Parameters

    - `x`: Integer that represents the x coordinate
    - `y`: Integer that represents the y coordiate

  ## Example

      iex> Boxes.answer(2, 4)
      "12"

  """
  @spec answer(pos_integer, pos_integer) :: binary
  def answer(x, y) do
    sum_x(x, 1)
    |> sum_y(x, y)
    |> to_string
  end

  @doc """
  Sums the x coordinate.

  It recursively sums the current value with the position value.

  This function is used by `answer/2`.

  ## Parameters

    - `x`: Integer that represents the x coordinate
    - `sum`: Integer that represents current sum. It should be called with `1` as its parameter

  ## Example

      iex> Boxes.sum_x(4, 1)
      10

  """
  @spec sum_x(pos_integer, pos_integer) :: pos_integer
  def sum_x(1, _sum), do: 1

  def sum_x(2, sum), do: sum + 2

  def sum_x(x, sum) do
    sum_x(x - 1, sum + x)
  end

  @doc """
  Sums the y coordinate.

  Recursively sums the current value with the position value.

  This function is used by `answer/2`.


  ## Parameters

    - `partial_result`: Integer that represents the partial sum calculated in `sum_x/2`
    - `x`: Integer that represents the x coordinate
    - `y`: Integer that represents the y coordinate

  ## Example

      iex> Boxes.sum_y(6, 3, 4)
      18

  """
  @spec sum_y(pos_integer, pos_integer, pos_integer) :: pos_integer
  def sum_y(partial_result, _x, 1), do: partial_result

  def sum_y(partial_result, x, y) do
    sum_y(partial_result + x, x + 1, y - 1)
  end

  @doc """
  Sums the y coordinate.

  Recursively sums the current value with the position value.

  This function is used by the function `reverse_answer/2`

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
