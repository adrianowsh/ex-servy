defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  describe "handle/1" do
    test "GET /wildthings" do
      request = """
      GET /wildthings HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r

      \r
      """

      response = handle(request)

      assert response == """
             HTTP/1.1 200 OK
             Content-Type: text/html
             Content-Length: 20

             Bears, Lions, Tigers
             """
    end
  end
end
