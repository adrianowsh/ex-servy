defmodule Servy.Response do
  alias Servy.Conv

  def format_response(%Conv{resp_body: body} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(body)}

    #{body}
    """
  end
end
