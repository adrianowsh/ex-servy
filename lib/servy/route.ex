defmodule Servy.Route do
  @pages_path Path.expand("../../lib/pages", __DIR__)

  alias Servy.PledgeController
  alias Servy.VideoCam
  alias Servy.BearController
  alias Servy.Api.BearController, as: Api
  alias Servy.Conv

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    PledgeController.index(conv)
  end

  def route(%{method: "GET", path: "/kaboom"}) do
    raise "Kaboom!"
  end

  def route(%{method: "GET", path: "/sensors"} = conv) do
    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    # gps_bigfoot = Fetcher.get_result(pid_4)
    gps_bigfoot = Task.await(task)

    %Conv{conv | status: 200, resp_body: inspect({snapshots, gps_bigfoot})}
  end

  # old version with spawn
  # def route(%{method: "GET", path: "/snapshots"} = conv) do
  #   parent = self()
  #   IO.inspect(parent, label: "Process of Servy.Route")

  #   pid_1 = Fetcher.async(fn -> VideoCam.get_snapshot("cam-1") end)
  #   pid_2 = Fetcher.async(fn -> VideoCam.get_snapshot("cam-2") end)
  #   pid_3 = Fetcher.async(fn -> VideoCam.get_snapshot("cam-3") end)

  #   snapshot1 = Fetcher.get_result(pid_1)
  #   snapshot2 = Fetcher.get_result(pid_2)
  #   snapshot3 = Fetcher.get_result(pid_3)

  #   snapshots = [snapshot1, snapshot2, snapshot3]
  #   %Conv{conv | status: 200, resp_body: inspect(snapshots)}
  # end

  def route(%{method: "GET", path: "/snapshots"} = conv) do
    parent = self()
    IO.inspect(parent, label: "Id process of the Servy.Route")

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    %Conv{conv | status: 200, resp_body: inspect(snapshots)}
  end

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %Conv{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Api.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    BearController.delete(conv)
  end

  def route(%Conv{method: _method, path: path} = conv) do
    %Conv{conv | status: 404, resp_body: "No #{path} here!"}
  end

  defp handle_file({:ok, content}, conv),
    do: %Conv{conv | status: 200, resp_body: content}

  defp handle_file({:error, :enoent}, conv),
    do: %{conv | status: 404, resp_body: "File not found"}

  defp handle_file({:error, reason}, conv),
    do: %{conv | status: 500, resp_body: "File error: #{reason}"}
end
