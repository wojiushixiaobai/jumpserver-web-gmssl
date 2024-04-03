ARG VERSION
ARG GM_VENDOR
FROM jumpserver/web:${VERSION} as web

FROM wojiushixiaobai/${GM_VENDOR}_nginx:latest
ARG TARGETARCH

ENV LANG=en_US.UTF-8

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends logrotate \
    && echo "no" | dpkg-reconfigure dash \
    && apt-get clean all \
    && rm -f /var/log/nginx/*.log \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

COPY --from=web /etc/nginx /etc/nginx
COPY --from=web /opt /opt
COPY --from=web /docker-entrypoint.d/40-init-config.sh /docker-entrypoint.d/40-init-config.sh