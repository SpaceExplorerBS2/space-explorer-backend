import cors_builder as cors
import gleam/http
import wisp

fn cors() {
  cors.new()
  |> cors.allow_origin("*")
  |> cors.allow_method(http.Get)
  |> cors.allow_method(http.Post)
}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use req <- cors.wisp_middleware(req, cors())

  handle_request(req)
}
