import gleam/dynamic/decode
import gleam/option.{type Option}
import pog

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
    iron: Option(Int),
    gold: Option(Int),
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
    use iron <- decode.field(5, decode.optional(decode.int))
    use gold <- decode.field(6, decode.optional(decode.int))
    decode.success(
      GetPlanetByIdRow(
        planet_id:,
        name:,
        hazards:,
        silver:,
        platinum:,
        iron:,
        gold:,
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
    iron: Option(Int),
    gold: Option(Int),
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
    use iron <- decode.field(5, decode.optional(decode.int))
    use gold <- decode.field(6, decode.optional(decode.int))
    decode.success(
      GetAllPlanetsRow(
        planet_id:,
        name:,
        hazards:,
        silver:,
        platinum:,
        iron:,
        gold:,
      ),
    )
  }

  let query = "select * from planets;"

  pog.query(query)
  |> pog.returning(decoder)
  |> pog.execute(db)
}
