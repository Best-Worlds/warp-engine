FROM debian:bullseye

LABEL maintainer="Bestworlds <dev@bestworlds.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y  --no-install-recommends rsync
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 873

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]