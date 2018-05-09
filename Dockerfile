# The version of Alpine to use for the final image
# This should match the version of Alpine that the `elixir:*-alpine` image uses
ARG ALPINE_VERSION=3.9

FROM elixir:1.8-alpine AS builder

# The following are build arguments used to change variable parts of the image.
# The name of your application/release (required)
ARG APP_NAME
# The version of the application we are building (required)
ARG APP_VERSION
# The environment to build with
ARG MIX_ENV=prod

ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION} \
    MIX_ENV=${MIX_ENV}

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache git build-base && \
  mix local.rebar --force && \
  mix local.hex --force

# This copies our app source code into the build container
COPY . .

RUN mix do deps.get, deps.compile, compile

RUN \
  mkdir -p /opt/built && \
  mix release --verbose && \
  cp _build/${MIX_ENV}/rel/${APP_NAME}/releases/${APP_VERSION}/${APP_NAME}.tar.gz /opt/built && \
  cd /opt/built && \
  tar -xzf ${APP_NAME}.tar.gz && \
  rm ${APP_NAME}.tar.gz

# From this line onwards, we're in a new image, which will be the image used in production
FROM alpine:${ALPINE_VERSION}

# The name of your application/release (required)
ARG APP_NAME

RUN apk update && \
    apk add --no-cache \
      bash \
      openssl-dev

ENV APP_NAME=${APP_NAME}


WORKDIR /opt/app

COPY --from=builder /opt/built .

VOLUME ["/opt/app/data"]

CMD trap 'exit' INT; /opt/app/bin/${APP_NAME} foreground
