import app/gelpers.{get_query_parameter}
import app/jsons/player.{map_player_by_id, map_players}
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

pub fn players(req: Request, con) -> Response {
  // This handler for `/comments` can respond to both GET and POST requests,
  // so we pattern match on the method here.
  case req.method {
    Get -> get_players(con)
    //Post -> create_comment(req)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

// pub fn planet(req: Request, con) -> Response {
//   // This handler for `/comments` can respond to both GET and POST requests,
//   // so we pattern match on the method here.
//   case req.method {
//     Get -> get_planet(con, req.query)
//     //Post -> create_comment(req)
//     _ -> wisp.method_not_allowed([Get, Post])
//   }
// }

fn get_players(con) -> Response {
  // In a later example we'll show how to read from a database.
  case sql.get_all_players(con) {
    Ok(res) -> wisp.response(200) |> wisp.json_body(map_players(res))
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
// fn get_planet(con, query: option.Option(String)) -> Response {
//   // In a later example we'll show how to read from a database.
//   let planet_json =
//     get_planet_from_db(con, query)
//     |> result.map(map_planet_by_id)

//   io.debug(planet_json)

//   case planet_json {
//     Ok(pj) -> wisp.response(200) |> wisp.json_body(pj)
//     Error(Nil) -> wisp.not_found()
//   }
//   // wisp.response(200)
//   // |> wisp.json_body(string_tree.from_string("{fuck:\"space\"}"))
// }
