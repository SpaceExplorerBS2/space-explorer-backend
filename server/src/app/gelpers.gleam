import gleam/list
import gleam/result
import gleam/string

pub fn get_query_parameter(query, param) {
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
