defmodule Metex.Worker do
  use GenServer
  @name MW
  ## Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: MW])
  end
  def get_temperature(location) do
    GenServer.call @name, {:location, location}
  end
  def get_stats do
    GenServer.call(@name, :get_stats)
  end
  def reset_stats do
    GenServer.cast(@name, :reset_stats)
  end
  def stop do
    GenServer.cast(@name, :stop)
  end

  ## Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end
  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end
  def handle_call({:location, location}, _from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp}℃ ", new_stats}
      _ ->
        {:reply, :error, stats}
    end
  end
  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end
  #TODO check lator Elixir 1.5.1
  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end
  def terminate(reason, stats) do
    IO.puts "Server termiated because of #{inspect reason}"
    inspect stats
    :ok
  end
  def handle_info(msg, stats) do
    IO.puts "received #{inspect msg}"
    {:noreply, stats}
  end

  ## Helper Functions
  def temperature_of(location) do
    location |> url_for |> HTTPoison.get |> parse_response
  end
  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey}"
  end
  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperture
  end
  defp parse_response({:error, %HTTPoison.Error{reason: reson}}) do
    {:error, reson}
  end
  defp compute_temperture(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> {:error, "somthing wrong"}
    end
  end
  defp apikey do
    System.get_env("OPEN_WEATHER_MAP_KEY")
  end
  def update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true ->
        Map.update!(old_stats, location,  &(&1 + 1))
      false ->
        Map.put_new(old_stats, location, 1)
    end
  end
end
