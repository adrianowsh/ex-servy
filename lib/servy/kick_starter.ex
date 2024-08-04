defmodule Servy.KickStarter do
  use GenServer

  def start do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_call({:EXIT, _pid, reason}, _state) do
    IO.puts("HTTPServer exited (#{inspect(reason)})")
    server_pid = start_server()
    {:nopeply, server_pid}
  end

  defp start_server do
    IO.puts("Starting the HTTP server...")
    server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
