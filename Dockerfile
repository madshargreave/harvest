# The version of Alpine to use for the final image
# This should match the version of Alpine that the `elixir:1.7.2-alpine` image uses
ARG ALPINE_VERSION=3.8

FROM elixir:1.7.2-alpine AS builder

# The following are build arguments used to change variable parts of the image.
# The name of your application/release (required)
ARG APP_NAME=harvest
# The version of the application we are building (required)
ARG APP_VSN=1.0.0
# The environment to build with
ARG MIX_ENV=prod
# Set this to true if this release is not a Phoenix app
ARG SKIP_PHOENIX=true
# If you are using an umbrella project, you can change this
# argument to the directory the Phoenix app is in so that the assets
# can be built
ARG PHOENIX_SUBDIR=.

ENV SKIP_PHOENIX=${SKIP_PHOENIX} \
    APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    git \
    build-base && \
    mix local.rebar --force && \
    mix local.hex --force

# This copies our app source code into the build container
COPY . .

RUN MIX_ENV=prod mix do deps.get, deps.compile, compile

RUN \
    mkdir -p /opt/built && \
    mix release --verbose --name ${APP_NAME} && \
    cp _build/${MIX_ENV}/rel/${APP_NAME}/releases/${APP_VSN}/${APP_NAME}.tar.gz /opt/built && \
    cd /opt/built && \
    tar -xzf ${APP_NAME}.tar.gz && \
    rm ${APP_NAME}.tar.gz

# From this line onwards, we're in a new image, which will be the image used in production
FROM mhart/alpine-node:11

# The name of your application/release (required)
ARG APP_NAME=harvest

RUN apk update && \
    apk add --no-cache \
    bash \
    openssl-dev

ENV REPLACE_OS_VARS=true \
    APP_NAME=${APP_NAME}

WORKDIR /opt/app

COPY --from=builder /opt/built .

EXPOSE 4000
CMD trap 'exit' INT; \
    /opt/app/bin/${APP_NAME} migrate && \
    /opt/app/bin/${APP_NAME} foreground
