defmodule Servy.Route do
  @pages_path Path.expand("../../lib/pages", __DIR__)

  alias Servy.VideoCam
  alias Servy.BearController
  alias Servy.Api.BearController, as: Api
  alias Servy.Conv

  def route(%{method: "GET", path: "/kaboom"}) do
    raise "Kaboom!"
  end

  def route(%{method: "GET", path: "/snapshots"} = conv) do
    parent = self()

    # the request-handling process
    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-1")}) end)
    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-2")}) end)
    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-3")}) end)
    # snapshot2 = spawn(fn -> VideoCam.get_snapshot("cam-2") end)
    # snapshot3 = spawn(fn -> VideoCam.get_snapshot("cam-3") end)

    snapshot1 =
      receive do
        {:result, filename} -> filename
      end

    snapshot2 =
      receive do
        {:result, filename} -> filename
      end

    snapshot3 =
      receive do
        {:result, filename} -> filename
      end

    snapshots = [snapshot1, snapshot2, snapshot3]

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
