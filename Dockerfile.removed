FROM elixir:alpine
ARG app_name=app
ENV MIX_ENV=prod REPLACE_OS_VARS=true TERM=xterm
WORKDIR /opt/app
RUN apk update \
    && mix local.rebar --force \
    && mix local.hex --force
COPY . .
RUN mix do deps.get, deps.compile, compile
RUN mix release --env=prod --verbose \
    && mv _build/prod/rel/${app_name} /opt/release \
    && mv /opt/release/bin/${app_name} /opt/release/bin/start_server
FROM alpine:latest
ARG project_id
ENV GCLOUD_PROJECT_ID=${project_id}
RUN apk update \
    && apk --no-cache --update add bash ca-certificates openssl-dev \
    && mkdir -p /usr/local/bin \
    && wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 \
    -O /usr/local/bin/cloud_sql_proxy \
    && chmod +x /usr/local/bin/cloud_sql_proxy \
    && mkdir -p /tmp/cloudsql
ENV PORT=8080 MIX_ENV=prod REPLACE_OS_VARS=true
WORKDIR /opt/app
EXPOSE ${PORT}
COPY --from=0 /opt/release .
CMD (/usr/local/bin/cloud_sql_proxy \
    -projects=${GCLOUD_PROJECT_ID} -dir=/tmp/cloudsql &); \
    exec /opt/app/bin/start_server foreground
