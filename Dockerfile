FROM alpine AS build

WORKDIR /
RUN apk add bash ca-certificates curl perl \
    && curl -4sSkLO https://raw.github.com/zfl9/gfwlist2privoxy/master/gfwlist2privoxy \
    && bash gfwlist2privoxy 127.0.0.1:1088

FROM v2fly/v2fly-core:v5.41.0
RUN apk --no-cache add privoxy
COPY --from=build /gfwlist.action /etc/privoxy/
RUN echo 'actionsfile gfwlist.action' >> /etc/privoxy/config \
    && sed -i '/listen-address/d' /etc/privoxy/config \
    && echo 'listen-address 0.0.0.0:8118' >> /etc/privoxy/config \
    && cp /etc/privoxy/default.filter.new /etc/privoxy/default.filter

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8118

ENTRYPOINT ["/entrypoint.sh"]
