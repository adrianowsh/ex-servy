defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  import Servy.Plugins, only: [rewrite_path: 1, track: 1]
  import Servy.Route
  import Servy.Parser, only: [parse: 1]
  import Servy.Response, only: [format_response: 1]
  @doc " Transforms the request into a response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    # |> log
    |> track
    |> route
    |> format_response
  end
end
