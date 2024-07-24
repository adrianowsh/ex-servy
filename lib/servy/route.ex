defmodule Servy.Route do
  @pages_path Path.expand("../../lib/pages", __DIR__)
  def route(%{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bear, Lions, Tigers"}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/bears" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bears #{id} "}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %{conv | status: 403, resp_body: "Bears must never be deleted!"}
  end

  def route(%{method: _method, path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} gere!"}
  end

  defp handle_file({:ok, content}, conv),
    do: %{conv | status: 200, resp_body: content}

  defp handle_file({:error, :enoent}, conv),
    do: %{conv | status: 404, resp_body: "File not found"}

  defp handle_file({:error, reason}, conv),
    do: %{conv | status: 500, resp_body: "File error: #{reason}"}
end
