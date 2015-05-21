defmodule SpheroServerTest do
  use ExUnit.Case

  test "test a mock roll ball 1" do
    map = File.read!("mock/roll_test.json")
    |> Poison.decode! keys: :atoms

IO.inspect map[:ball]

    SpheroServer.roll(map.ball, map.speed, map.angle)
  end

end
