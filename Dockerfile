FROM mhart/alpine-node:4
MAINTAINER JD Courtoy <jd.courtoy@gmail.com>

ENV GHOST_SOURCE /usr/src/app
ENV GHOST_CONTENT /var/lib/ghost
ENV GHOST_VERSION 0.8.0

WORKDIR $GHOST_SOURCE
RUN mkdir -p "$GHOST_CONTENT"
VOLUME $GHOST_CONTENT

RUN apk --no-cache add tar tini bash \
  && apk --no-cache add --virtual devs gcc make python wget unzip ca-certificates \
  && wget -O ghost.zip "https://ghost.org/archives/ghost-${GHOST_VERSION}.zip" \
  && unzip ghost.zip \
  && npm install --production \
  && rm ghost.zip \
  && apk del devs \
  && npm cache clean \
  && rm -rf /tmp/npm*

COPY ./config.js $GHOST_SOURCE
COPY ./entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 2368
CMD [ "npm", "start" ]
