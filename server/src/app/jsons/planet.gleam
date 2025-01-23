import gleam/json
import gleam/option.{None, Some}
import pog
import sql
import youid/uuid.{type Uuid}

pub fn map_planets(query_res: pog.Returned(sql.GetAllPlanetsRow)) {
  query_res.rows
  |> json.array(fn(x) {
    json.object([
      #("id", json.string(x.planet_id)),
      #("name", json.string(x.name)),
      #("hazards", case x.hazards {
        Some(hazards) -> json.array(hazards, json.string)
        None -> json.null()
      }),
      #(
        "resources",
        json.object([#("iron", json.int(x.iron)), #("gold", json.int(x.gold))]),
      ),
      #("x", json.int(x.x)),
      #("y", json.int(x.y)),
      #("rad", json.int(x.rad)),
    ])
  })
  |> json.to_string_tree
}

pub fn map_planet_by_id(query_res: sql.GetPlanetByIdRow) {
  query_res
  |> fn(x) {
    json.object([
      #("id", json.string(x.planet_id)),
      #("name", json.string(x.name)),
      #("hazards", case x.hazards {
        Some(hazards) -> json.array(hazards, json.string)
        None -> json.null()
      }),
      #(
        "resources",
        json.object([#("iron", json.int(x.iron)), #("gold", json.int(x.gold))]),
      ),
      #("x", json.int(x.x)),
      #("y", json.int(x.y)),
      #("rad", json.int(x.rad)),
    ])
  }
  |> json.to_string_tree
}
