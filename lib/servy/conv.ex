defmodule Servy.Conv do
  defstruct method: "",
            params: %{},
            headers: %{},
            path: "",
            resp_content_type: "text/html",
            resp_body: "",
            status: nil

  def full_status(%{status: status}) do
    "#{status} #{status_reason(status)}"
  end

  defp status_reason(code) do
    codes = %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }

    codes[code]
  end
end
