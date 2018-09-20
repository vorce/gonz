defmodule Gonz.Plug.Site do
  @moduledoc """
  Serve the site from the build dir.
  We only need plug and cowboy because we need to be able to browse the site when developing it.
  """
  @behaviour Plug

  require Logger

  @static_at "/"
  @static_base_config Plug.Static.init(at: @static_at, from: Gonz.Build.default_output_dir())

  def init(opts), do: opts

  # Serve the index file from build dir if / is accessed
  def call(%Plug.Conn{path_info: [], state: state} = conn, opts) when state in [:unset, :set] do
    build_dir = Keyword.get(opts, :build_dir, Gonz.Build.default_output_dir())
    path = Path.expand("#{build_dir}/index.html")

    if File.exists?(path) do
      conn
      |> Plug.Conn.send_file(200, path)
      |> Plug.Conn.halt()
    else
      Logger.error("index.html not found in directory \"#{build_dir}\". Build the site with: mix gonz.build")
      not_found(conn)
    end
  end

  # Try to serve static content from the build dir.
  def call(conn, opts) do
    build_dir = Keyword.get(opts, :build_dir, Gonz.Build.default_output_dir())
    static_cfg = Map.put(@static_base_config, :from, build_dir)

    conn
    |> Plug.Static.call(static_cfg)
    |> not_found()
  end

  def not_found(%Plug.Conn{state: :unset} = conn) do
    Logger.debug("Could not find #{inspect(conn.request_path)} - responding with 404")

    Plug.Conn.send_resp(
      conn,
      404,
      "Resource not found. Build your site with: mix gonz.build and then go to http://localhost:4000/"
    )
  end

  def not_found(conn), do: conn
end
