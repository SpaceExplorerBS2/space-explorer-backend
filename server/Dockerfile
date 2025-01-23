ARG GLEAM_VERSION=v1.6.3

FROM ghcr.io/gleam-lang/gleam:${GLEAM_VERSION}-erlang-alpine AS build

COPY . /build/server

# Compile the star_bff code
RUN cd /build/server \
  && gleam export erlang-shipment

# Start from a clean slate
FROM ghcr.io/gleam-lang/gleam:${GLEAM_VERSION}-erlang-alpine

# Copy the compiled star_bff code from the builder stage
COPY --from=build /build/server/build/erlang-shipment /app

# Run the star_bff
EXPOSE 7211
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]