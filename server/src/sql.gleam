import gleam/dynamic/decode
import gleam/option.{type Option}
import pog

/// A row you get from running the `get_player_by_id` query
/// defined in `./src/sql/get_player_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetPlayerByIdRow {
  GetPlayerByIdRow(
    player_id: String,
    name: String,
    fuel: Int,
    current_planet_id: Option(String),
    iron: Int,
    gold: Int,
  )
}

/// Runs the `get_player_by_id` query
/// defined in `./src/sql/get_player_by_id.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_player_by_id(db, arg_1) {
  let decoder = {
    use player_id <- decode.field(0, decode.string)
    use name <- decode.field(1, decode.string)
    use fuel <- decode.field(2, decode.int)
    use current_planet_id <- decode.field(3, decode.optional(decode.string))
    use iron <- decode.field(4, decode.int)
    use gold <- decode.field(5, decode.int)
    decode.success(
      GetPlayerByIdRow(
        player_id:,
        name:,
        fuel:,
        current_planet_id:,
        iron:,
        gold:,
      ),
    )
  }

  let query = "SELECT * FROM players where player_id = $1;"

  pog.query(query)
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_planet_by_id` query
/// defined in `./src/sql/get_planet_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetPlanetByIdRow {
  GetPlanetByIdRow(
    planet_id: String,
    name: String,
    hazards: Option(List(String)),
    silver: Option(Int),
    platinum: Option(Int),
    iron: Int,
    gold: Int,
    x: Int,
    y: Int,
    rad: Int,
  )
}

/// Runs the `get_planet_by_id` query
/// defined in `./src/sql/get_planet_by_id.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_planet_by_id(db, arg_1) {
  let decoder = {
    use planet_id <- decode.field(0, decode.string)
    use name <- decode.field(1, decode.string)
    use hazards <- decode.field(2, decode.optional(decode.list(decode.string)))
    use silver <- decode.field(3, decode.optional(decode.int))
    use platinum <- decode.field(4, decode.optional(decode.int))
    use iron <- decode.field(5, decode.int)
    use gold <- decode.field(6, decode.int)
    use x <- decode.field(7, decode.int)
    use y <- decode.field(8, decode.int)
    use rad <- decode.field(9, decode.int)
    decode.success(
      GetPlanetByIdRow(
        planet_id:,
        name:,
        hazards:,
        silver:,
        platinum:,
        iron:,
        gold:,
        x:,
        y:,
        rad:,
      ),
    )
  }

  let query = "select * from planets
where planet_id = $1
ORDER by planet_id
fetch first 1 rows only"

  pog.query(query)
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_all_player` query
/// defined in `./src/sql/get_all_player.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetAllPlayerRow {
  GetAllPlayerRow(
    player_id: String,
    name: String,
    fuel: Int,
    current_planet_id: Option(String),
    iron: Int,
    gold: Int,
  )
}

/// Runs the `get_all_player` query
/// defined in `./src/sql/get_all_player.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_all_player(db) {
  let decoder = {
    use player_id <- decode.field(0, decode.string)
    use name <- decode.field(1, decode.string)
    use fuel <- decode.field(2, decode.int)
    use current_planet_id <- decode.field(3, decode.optional(decode.string))
    use iron <- decode.field(4, decode.int)
    use gold <- decode.field(5, decode.int)
    decode.success(
      GetAllPlayerRow(player_id:, name:, fuel:, current_planet_id:, iron:, gold:,
      ),
    )
  }

  let query = "SELECT * FROM players;"

  pog.query(query)
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_all_planets` query
/// defined in `./src/sql/get_all_planets.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetAllPlanetsRow {
  GetAllPlanetsRow(
    planet_id: String,
    name: String,
    hazards: Option(List(String)),
    silver: Option(Int),
    platinum: Option(Int),
    iron: Int,
    gold: Int,
    x: Int,
    y: Int,
    rad: Int,
  )
}

/// Runs the `get_all_planets` query
/// defined in `./src/sql/get_all_planets.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_all_planets(db) {
  let decoder = {
    use planet_id <- decode.field(0, decode.string)
    use name <- decode.field(1, decode.string)
    use hazards <- decode.field(2, decode.optional(decode.list(decode.string)))
    use silver <- decode.field(3, decode.optional(decode.int))
    use platinum <- decode.field(4, decode.optional(decode.int))
    use iron <- decode.field(5, decode.int)
    use gold <- decode.field(6, decode.int)
    use x <- decode.field(7, decode.int)
    use y <- decode.field(8, decode.int)
    use rad <- decode.field(9, decode.int)
    decode.success(
      GetAllPlanetsRow(
        planet_id:,
        name:,
        hazards:,
        silver:,
        platinum:,
        iron:,
        gold:,
        x:,
        y:,
        rad:,
      ),
    )
  }

  let query = "select * from planets;"

  pog.query(query)
  |> pog.returning(decoder)
  |> pog.execute(db)
}
