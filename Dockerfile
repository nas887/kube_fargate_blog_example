FROM alpine:3.10.3 as build

ENV HUGO_VERSION 0.60.1
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

RUN set -x && \
  apk add --update wget ca-certificates && \
  apk add bash && \
  wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
  tar xzf ${HUGO_BINARY} && \
  rm -r ${HUGO_BINARY} && \
  mv hugo /usr/bin && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

COPY ./ /site
WORKDIR /site
RUN /usr/bin/hugo

maintainer Neil Shah <@kneelshah>

FROM nginx:alpine

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

COPY --from=build /site/public /var/www/site

WORKDIR /var/www/site

CMD ["nginx", "-g", "daemon off;"]
