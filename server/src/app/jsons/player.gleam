// import gleam/json
// import gleam/option.{None, Some}
// import pog
// import sql
// import youid/uuid.{type Uuid}

// // player_id: String,
// //     name: String,
// //     fuel: Option(Int),
// //     current_planet_id: Option(String),

// pub fn map_players(query_res: pog.Returned(sql.GetAllPlayerRow)) {
//   query_res.rows
//   |> json.array(fn(x) {
//     json.object([
//       #("id", json.string(x.player_id)),
//       #("name", json.string(x.name)),
//       #("hazards", case x.hazards {
//         Some(hazards) -> json.array(hazards, json.string)
//         None -> json.null()
//       }),
//       #(
//         "resources",
//         json.object([#("iron", json.int(x.iron)), #("gold", json.int(x.gold))]),
//       ),
//       #("x", json.int(x.x)),
//       #("y", json.int(x.y)),
//       #("rad", json.int(x.rad)),
//     ])
//   })
//   |> json.to_string_tree
// }

// pub fn map_player_by_id(query_res: sql.GetPlanetByIdRow) {
//   query_res
//   |> fn(x) {
//     json.object([
//       #("id", json.string(x.planet_id)),
//       #("name", json.string(x.name)),
//       #("hazards", case x.hazards {
//         Some(hazards) -> json.array(hazards, json.string)
//         None -> json.null()
//       }),
//       #(
//         "resources",
//         json.object([#("iron", json.int(x.iron)), #("gold", json.int(x.gold))]),
//       ),
//       #("x", json.int(x.x)),
//       #("y", json.int(x.y)),
//       #("rad", json.int(x.rad)),
//     ])
//   }
//   |> json.to_string_tree
// }
