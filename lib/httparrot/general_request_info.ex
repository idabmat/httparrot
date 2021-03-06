defmodule HTTParrot.GeneralRequestInfo do
  def retrieve(req) do
    {args, req} = :cowboy_req.qs_vals(req)
    {headers, req} = :cowboy_req.headers(req)
    {url, req} = :cowboy_req.url(req)
    {{ip, port}, req} = :cowboy_req.peer(req)

    ip = case {ip, port} do
      {:local, _} -> ""
      _ -> :inet_parse.ntoa(ip) |> to_string
    end

    args = group_by_keys(args)

    {[args: args, headers: headers, url: url, origin: ip], req}
  end

  @doc """
  Group by keys and if duplicated keys, aggregate them as a list

  iex> group_by_keys([a: "v1", a: "v2", b: "v3", a: "v4"])
  %{a: ["v1", "v2", "v4"], b: "v3"}
  """
  @spec group_by_keys(list) :: map
  def group_by_keys([]), do: %{}
  def group_by_keys(args) do
    args
    |> Enum.map(fn {k, v} -> %{k => v} end)
    |> Enum.reduce(fn m, acc ->
      Map.merge(m, acc, fn _k, v1, v2 ->
        List.wrap(v2) ++ List.wrap(v1)
      end)
    end)
  end
end
