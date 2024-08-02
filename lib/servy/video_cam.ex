defmodule Servy.VideoCam do
  def get_snapshot(camera_name) do
    IO.inspect(self(), label: "Process of Servy.VideoCam")
    :timer.sleep(1000)

    "#{camera_name}-snapshot.jpg"
  end
end
