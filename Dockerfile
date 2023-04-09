FROM node:19.8.1-alpine3.17 AS installer
RUN apk add --no-cache \
    build-base=0.5-r3 \
    python3=3.10.11-r0 && \
    npm i -g -f npm@9.6.4 @devcontainers/cli@0.36.0
FROM docker:23.0.3-cli-alpine3.17 AS docker_image
FROM node:19.8.1-alpine3.17
COPY --from=installer /usr/local/lib/node_modules/@devcontainers /usr/local/lib/node_modules/@devcontainers
COPY --from=docker_image /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker_image /usr/local/libexec /usr/local/libexec
RUN ln -s /usr/local/lib/node_modules/@devcontainers/cli/devcontainer.js /usr/local/bin/devcontainer && \
    ln -s /usr/local/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
WORKDIR /
ENTRYPOINT ["devcontainer"]
