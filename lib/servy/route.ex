defmodule Servy.Route do
  @pages_path Path.expand("../../lib/pages", __DIR__)

  alias Servy.BearController

  alias Servy.Conv

  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %Conv{conv | status: 200, resp_body: "Bear, Lions, Tigers"}
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
    %Conv{conv | status: 404, resp_body: "No #{path} gere!"}
  end

  defp handle_file({:ok, content}, conv),
    do: %Conv{conv | status: 200, resp_body: content}

  defp handle_file({:error, :enoent}, conv),
    do: %{conv | status: 404, resp_body: "File not found"}

  defp handle_file({:error, reason}, conv),
    do: %{conv | status: 500, resp_body: "File error: #{reason}"}
end
