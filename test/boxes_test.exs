defmodule BoxesTest do
  use ExUnit.Case
  doctest Boxes

  test "answer/2" do
    assert Boxes.answer(1, 1) == "1"
    assert Boxes.answer(2, 2) == "5"
    assert Boxes.answer(2, 4) == "12"
    assert Boxes.answer(4, 1) == "10"
    assert Boxes.answer(4, 2) == "14"
    assert Boxes.answer(612, 231) == "354673"
    assert Boxes.answer(11111, 11111) == "246886421"
    # This is the bad test case
    refute Boxes.answer(100_000, 100_000) == "20000000001"
    # This is how I fixed it
    assert Boxes.answer(100_000, 100_000) == "19999800001"

    assert Boxes.answer(13457, 100_000) == "6436088697"
  end

  test "sum_x/2" do
    assert Boxes.sum_x(1, 1) == 1
    assert Boxes.sum_x(6, 1) == 21
    assert Boxes.sum_x(4, 1) == 10
  end

  test "sum_y/3" do
    assert Boxes.sum_y(1, 1, 1) == 1
    assert Boxes.sum_y(6, 3, 4) == 18
    assert Boxes.sum_y(10, 4, 2) == 14
  end

  test "find_partial_sum_on_wall/1" do
    assert Boxes.find_partial_sum_on_wall(1) == 1
    assert Boxes.find_partial_sum_on_wall(2) == 2
    assert Boxes.find_partial_sum_on_wall(3) == 4
    assert Boxes.find_partial_sum_on_wall(4) == 7
    assert Boxes.find_partial_sum_on_wall(5) == 11
  end

  test "find_x_component/3" do
    assert Boxes.find_x_component(1, 1, 1) == 1
    assert Boxes.find_x_component(8, 4, 3) == 2
    assert Boxes.find_x_component(9, 2, 2) == 3
    assert Boxes.find_x_component(14, 2, 2) == 4
    assert Boxes.find_x_component(13, 4, 3) == 3
  end

  test "reverse_answer/2" do
    assert Boxes.reverse_answer(3, 13) == 3
    assert Boxes.reverse_answer(2, 14) == 4
    assert Boxes.reverse_answer(4, 7) == 1
    assert Boxes.reverse_answer(4, 12) == 2
    assert Boxes.reverse_answer(1, 15) == 5
    assert Boxes.reverse_answer(100_000, 6_436_088_697) == 13457
  end
end
