import app/web
import gleam/http.{Get, Post}
import gleam/json
import gleam/list
import gleam/option
import gleam/string
import gleam/string_tree
import pog

// import sql
import wisp.{type Request, type Response}
import youid/uuid.{type Uuid}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  let connectionstring = "postgres://postgres:toor@localhost:5432/tttdb"
  let db =
    pog.default_config()
    |> pog.host("localhost")
    |> pog.database("ttt_back")
    |> pog.user("postgres")
    |> pog.password(option.Some("toor"))
    |> pog.pool_size(15)
    |> pog.connect

  let games_state = games(_, db)

  // Wisp doesn't have a special router abstraction, instead we recommend using
  // regular old pattern matching. This is faster than a router, is type safe,
  // and means you don't have to learn or be limited by a special DSL.
  //
  case wisp.path_segments(req) {
    // This matches `/`.
    [] -> home_page(req)

    // This matches `/comments`.
    ["games"] -> games_state(req)

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

fn games(req: Request, con) -> Response {
  // This handler for `/comments` can respond to both GET and POST requests,
  // so we pattern match on the method here.
  case req.method {
    Get -> get_games(con)
    Post -> create_comment(req)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

// fn map_games(query_res: pog.Returned(sql.SelectAllGamesRow)) {
//   query_res.rows
//   |> json.array(fn(e) {
//     json.object([
//       #("id", case e.id {
//         option.Some(x) -> json.string(uuid.to_string(x))
//         option.None -> json.null()
//       }),
//     ])
//   })
// }

fn get_games(con) -> Response {
  // In a later example we'll show how to read from a database.
  // case sql.select_all_games(con) {
  //   Ok(res) -> wisp.json_body(string_tree.from_string(map_games(res)))
  //   Error(x) -> wisp.not_found()
  // }
  wisp.response(200)
  |> wisp.json_body(string_tree.from_string("{fuck:\"space\"}"))
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
