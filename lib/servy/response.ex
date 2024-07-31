defmodule Servy.Response do
  alias Servy.Conv

  def format_response(%Conv{resp_body: body, resp_content_type: resp_content_type} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{resp_content_type}\r
    Content-Length: #{byte_size(body)}\r
    \r
    #{body}
    """
  end
end
