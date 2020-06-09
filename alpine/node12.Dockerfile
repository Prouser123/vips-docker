FROM node:12-alpine

FROM jcxldn/vips-docker:base-alpine

COPY --from=0 /usr/local/ /usr/
COPY --from=0 /opt/ /opt/

# Nodejs is built in /usr/local, but we are moving it to /usr for ease of use.
# Yarn is installed to /opt/yarn-{version}

RUN apk upgrade --no-cache -U && \
    apk add --no-cache libstdc++ && \
    node -v && npm -v && npx -v && yarn -v && yarnpkg -v && \
    rm -rf /var/cache-apk/* \