defmodule SpheroServer do
  use Application

  import Logger

  def start(_type, _args) do
    {:ok, self}
  end

  def connect_balls() do

    :ets.new(:ball_handler, [:named_table])

    if length(:ets.lookup(:ball_handler, "ball1")) < 1 do 
      {:ok, pid} = Sphero.Client.start(Application.get_env(:sphero_server, :ball1))
      :ets.insert(:ball_handler, {"ball1", pid})  
      :timer.sleep(3000)
    end

    if length(:ets.lookup(:ball_handler, "ball2")) < 1 do 
      {:ok, pid} = Sphero.Client.start(Application.get_env(:sphero_server, :ball2))
      :ets.insert(:ball_handler, {"ball2", pid})
      :timer.sleep(3000)
    end
  
  end

  def accept_commands do 
    response = HTTPoison.get!("http://sphero-api.hopto.org/nextCommand", keys: :atoms) 

    if response.body != "" do 
      command = Poison.Parser.parse!(response.body, keys: :atoms)
      Logger.info(inspect command)
      case command.action do 
        "color" -> set_rgb(command.ball, command.red, command.green, command.blue)
        "roll"  -> roll(command.ball, command.speed, command.angle)
        _ -> Logger.info(inspect command.action)
      end

    end 

    :timer.sleep(300)
    accept_commands
  end

  def roll(myball, speed, angle) do

    case myball do 
      "0" -> 
        Sphero.Client.roll(get_my_ball(:ball1), String.to_integer(speed), String.to_integer(angle))
      "1" -> 
        Sphero.Client.roll(get_my_ball(:ball2), String.to_integer(speed), String.to_integer(angle))
      "2" -> 
        Sphero.Client.roll(get_my_ball(:ball1), String.to_integer(speed), String.to_integer(angle)) && Sphero.Client.roll(get_my_ball(:ball2), String.to_integer(speed), String.to_integer(angle))
    end
  end

 def set_rgb(myball, red, green, blue) do
    case myball do 
       "0" -> 
        Sphero.Client.set_rgb(get_my_ball(:ball1), String.to_integer(red) , String.to_integer(green), String.to_integer(blue))
       "1" -> 
        Sphero.Client.set_rgb(get_my_ball(:ball2), String.to_integer(red) , String.to_integer(green), String.to_integer(blue))
       "2" -> 
        Sphero.Client.set_rgb(get_my_ball(:ball1), Strint.to_integer(red) , String.to_integer(green), String.to_integer(blue)) && Sphero.Client.set_rgb(Process.get(:ball2), String.to_integer(red), String.to_integer(green), String.to_integer(blue))
    end
 end

 def get_my_ball(ball) do
    [{key, value}] = :ets.lookup(:ball_handler, Atom.to_string(ball))
    value 
 end

end

