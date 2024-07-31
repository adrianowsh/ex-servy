defmodule Servy.Response do
  alias Servy.Conv

  def format_response(%Conv{resp_body: body, resp_content_type: resp_content_type} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: #{resp_content_type}
    Content-Length: #{byte_size(body)}

    #{body}
    """
  end
end
