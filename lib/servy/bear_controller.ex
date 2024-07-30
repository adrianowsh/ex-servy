defmodule Servy.BearController do
  alias Servy.Bear
  alias Servy.Wildthings

  @template_path Path.expand("../templates", __DIR__)

  defp render(conv, template, bindings) do
    content =
      @template_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{
      conv
      | status: 201,
        resp_body: "Create a #{type} bear named #{name}!"
    }
  end

  def delete(conv) do
    %{conv | status: 403, resp_body: "Bears must never be deleted!"}
  end
end
