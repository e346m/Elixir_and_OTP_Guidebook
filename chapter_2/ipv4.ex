defmodule IPv4Parser do
  def parser(pcap) do
    case File.read(pcap) do
      {:ok, packet} ->
      <<>>
    end
  end
end
