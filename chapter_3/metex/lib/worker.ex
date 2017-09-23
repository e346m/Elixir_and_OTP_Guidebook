defmodule Metex.Worker do
  def server(cities) do
    coordinator_pid = spawn(Metex.Coordinator, :loop, [[], Enum.count(cities)])
    cities |> Enum.each(fn city ->
      worker_pid = spawn(__MODULE__,  :worker, [])
      send worker_pid, {coordinator_pid, city}
    end)
  end
  def worker do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok,  temperature_of(location)})
      _ ->
        IO.puts "don't know haw to process this message"
    end
  end
  def temperature_of(location) do
    result = location |> url_for |> HTTPoison.get |> parse_response

    case result do
      {:ok, temp} ->
        "#{location} #{temp}℃ "
      {:error, reason}->
        "#{location} not found"
    end
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
    "3bdbc848645d23fd8adf95d36a9e7616"
  end
end
