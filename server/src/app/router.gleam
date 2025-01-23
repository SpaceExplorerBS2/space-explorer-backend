import app/web
import envoy
import gleam/erlang/os
import gleam/http.{Get, Post}
import gleam/http/response
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam/string_tree
import pog

import app/jsons/planet.{map_planet_by_id, map_planets}

import sql
import wisp.{type Request, type Response}
import youid/uuid.{type Uuid}

fn get_query_parameter(query, param) {
  query
  |> string.split("&")
  |> list.map(string.split_once(_, "="))
  |> list.map(fn(x) { result.map(x, fn(y) { #(string.lowercase(y.0), y.1) }) })
  |> list.find(fn(x) {
    case x {
      Ok(#(pname, _)) if pname == param -> True
      _ -> False
    }
  })
  |> fn(x) {
    case x {
      Ok(a) -> a
      Error(nil) -> Error(nil)
    }
  }
}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)
  io.debug("load env")
  let assert Ok(host) = envoy.get("DATABASE_HOST")
  let assert Ok(user) = envoy.get("DATABASE_USER")
  let assert Ok(database) = envoy.get("DATABASE")
  let assert Ok(port) = envoy.get("DATABASE_PORT")
  let assert Ok(password) = envoy.get("DATABASE_PASSWORD")
  let assert Ok(port_int) = int.parse(port)

  let db =
    pog.default_config()
    |> pog.host(host)
    |> pog.database(database)
    |> pog.user(user)
    |> pog.port(port_int)
    |> pog.password(option.Some(password))
    |> pog.pool_size(15)
    |> pog.connect

  let get_planets_with_state = planets(_, db)
  let get_planet_with_state = planet(_, db)

  // Wisp doesn't have a special router abstraction, instead we recommend using
  // regular old pattern matching. This is faster than a router, is type safe,
  // and means you don't have to learn or be limited by a special DSL.
  //
  case wisp.path_segments(req) {
    // This matches `/`.
    [] -> home_page(req)

    // This matches `/comments`.
    ["planets"] -> get_planets_with_state(req)
    ["planet"] -> get_planet_with_state(req)

    // This matches all other paths.
    _ -> wisp.not_found()
  }
}

fn home_page(req: Request) -> Response {
  // The home page can only be accessed via GET requests, so this middleware is
  // used to return a 405: Method Not Allowed response for all other methods.
  use <- wisp.require_method(req, Get)

  let html = string_tree.from_string("FSpace-Backend")
  wisp.ok()
  |> wisp.html_body(html)
}

fn planets(req: Request, con) -> Response {
  // This handler for `/comments` can respond to both GET and POST requests,
  // so we pattern match on the method here.
  case req.method {
    Get -> get_planets(con)
    //Post -> create_comment(req)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn planet(req: Request, con) -> Response {
  // This handler for `/comments` can respond to both GET and POST requests,
  // so we pattern match on the method here.
  case req.method {
    Get -> get_planet(con, req.query)
    //Post -> create_comment(req)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn get_planets(con) -> Response {
  // In a later example we'll show how to read from a database.
  case sql.get_all_planets(con) {
    Ok(res) -> wisp.response(200) |> wisp.json_body(map_planets(res))
    Error(x) -> wisp.not_found()
  }
  // wisp.response(200)
  // |> wisp.json_body(string_tree.from_string("{fuck:\"space\"}"))
}

fn get_planet_from_db(con, query) -> Result(sql.GetPlanetByIdRow, Nil) {
  let assert Some(qr) = query
  use #(_, planet_id) <- result.try(get_query_parameter(qr, "planetid"))
  io.debug(planet_id)
  use res <- result.try(
    sql.get_planet_by_id(con, planet_id) |> result.map_error(fn(_) { Nil }),
  )
  list.first(res.rows)
}

fn get_planet(con, query: option.Option(String)) -> Response {
  // In a later example we'll show how to read from a database.
  let planet_json =
    get_planet_from_db(con, query)
    |> result.map(map_planet_by_id)

  io.debug(planet_json)

  case planet_json {
    Ok(pj) -> wisp.response(200) |> wisp.json_body(pj)
    Error(Nil) -> wisp.not_found()
  }
  // wisp.response(200)
  // |> wisp.json_body(string_tree.from_string("{fuck:\"space\"}"))
}

fn create_comment(_req: Request) -> Response {
  // In a later example we'll show how to parse data from the request body.
  let html = string_tree.from_string("Created")
  wisp.created()
  |> wisp.html_body(html)
}

fn show_comment(req: Request, id: String) -> Response {
  use <- wisp.require_method(req, Get)

  // The `id` path parameter has been passed to this function, so we could use
  // it to look up a comment in a database.
  // For now we'll just include in the response body.
  let html = string_tree.from_string("Comment with id " <> id)
  wisp.ok()
  |> wisp.html_body(html)
}
