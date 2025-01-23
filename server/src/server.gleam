import app/router
import envoy
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/option
import mist
import pog
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)

  io.debug("load env")
  let assert Ok(host) = envoy.get("DATABASE_HOST")
  let assert Ok(user) = envoy.get("DATABASE_USER")
  let assert Ok(database) = envoy.get("DATABASE")
  let assert Ok(port) = envoy.get("DATABASE_PORT")
  let assert Ok(password) = envoy.get("DATABASE_PASSWORD")
  let assert Ok(port_int) = int.parse(port)

  io.debug(#(user, password, host, port, database))

  let db =
    pog.default_config()
    |> pog.host(host)
    |> pog.database(database)
    |> pog.user(user)
    |> pog.port(port_int)
    |> pog.password(option.Some(password))
    |> pog.pool_size(15)
    |> pog.connect

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request(_, db), secret_key_base)
    |> mist.new
    |> mist.bind("0.0.0.0")
    |> mist.port(7211)
    |> mist.start_http

  process.sleep_forever()
}
