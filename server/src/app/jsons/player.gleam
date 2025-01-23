import gleam/json
import gleam/option.{None, Some}
import pog
import sql
import youid/uuid.{type Uuid}

pub fn map_players(query_res: pog.Returned(sql.GetAllPlayerRow)) {
  query_res.rows
  |> json.array(fn(x) {
    json.object([
      #("playerId", json.string(x.player_id)),
      #("name", json.string(x.name)),
      #("gold", json.int(x.gold)),
      #("iron", json.int(x.iron)),
      #("fuel", json.int(x.fuel)),
    ])
  })
  |> json.to_string_tree
}

pub fn map_player_by_id(query_res: sql.GetPlayerByIdRow) {
  query_res
  |> fn(x) {
    json.object([
      #("playerId", json.string(x.player_id)),
      #("name", json.string(x.name)),
      #("gold", json.int(x.gold)),
      #("iron", json.int(x.iron)),
      #("fuel", json.int(x.fuel)),
    ])
  }
  |> json.to_string_tree
}
