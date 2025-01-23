import app/handlers/planet as planet_handler
import app/handlers/player as player_handler
import app/jsons/planet as planet_jsons
import app/jsons/player as player_jsons
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
import sql
import wisp.{type Request, type Response}
import youid/uuid.{type Uuid}

pub fn handle_request(req: Request, db) -> Response {
  use req <- web.middleware(req)

  let get_planets_with_state = planet_handler.planets(_, db)
  let get_planet_with_state = planet_handler.planet(_, db)
  let get_players_with_state = player_handler.players(_, db)
  //let get_player_with_state = player(_, db)

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
    ["players"] -> get_players_with_state(req)

    //["player"] -> get_planet_with_state(req)
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
