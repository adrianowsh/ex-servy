defmodule Servy.Fetcher do
  def async(fun) do
    parent = self()
    IO.inspect(parent, label: "Process of Servy.Fetcher")
    spawn(fn -> send(parent, {self(), :result, fun.()}) end)
  end

  def get_result(pid) do
    receive do
      {^pid, :result, value} -> value
    after
      2000 ->
        raise("time out!")
    end
  end
end
