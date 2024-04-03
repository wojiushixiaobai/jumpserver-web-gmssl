ARG VERSION
ARG GM_VENDOR
FROM jumpserver/web:${VERSION} as web

FROM wojiushixiaobai/${GM_VENDOR}_nginx:latest
ARG TARGETARCH

ENV LANG=zh_CN.UTF-8

ARG APT_MIRROR=http://mirrors.ustc.edu.cn
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=web \
    sed -i "s@http://.*.debian.org@${APT_MIRROR}@g" /etc/apt/sources.list \
    && rm -f /etc/cron.daily/apt-compat \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends logrotate \
    && echo "no" | dpkg-reconfigure dash \
    && echo "zh_CN.UTF-8" | dpkg-reconfigure locales \
    && rm -f /var/log/nginx/*.log \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

COPY --from=web /etc/nginx /etc/nginx
COPY --from=web /opt /opt
COPY --from=web /docker-entrypoint.d/40-init-config.sh /docker-entrypoint.d/40-init-config.sh