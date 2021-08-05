# docker-v2fly-privoxy

Docker版 v2ray 客户端,v2ray 结合 privoxy 来使用 gfwlist 规则来实现代理过滤, 并实现 socks5 代理转 http 代理，可用于群晖。

> DockerHub: https://hub.docker.com/r/bloodstar/v2fly-privoxy

## 运行
```shell
docker run -dti -p 8118:8118 \
    -v /path/to/v2ray/config.json:/etc/v2ray/config.json \ 
    bloodstar/v2fly-privoxy
```
- `8118` 端口为 http 代理端口
- `/path/to/v2ray/config.json` 为宿主机上 v2ray 配置文件
- v2ray 配置文件中的 socks 端口必须是 `1080`

或者自定义 privoxy 配置文件
```shell
docker run -dti -p 8118:8118 \
    -v /path/to/v2ray/config.json:/etc/v2ray/config.json \
    -v /path/to/privoxy/config:/etc/privoxy/config \ 
    bloodstar/v2fly-privoxy
```

- `/path/to/privoxy/config` 为宿主机上的 privoxy 配置文件

# docker compose
```
  v2fly:
    container_name:  v2fly
    hostname: v2fly
    image: bloodstar/v2fly-privoxy
    volumes:
      - ${USERDIR}/v2ray/etc/:/etc/v2ray/
      - ${USERDIR}/v2ray/log/:/var/log/v2ray/
      - ${USERDIR}/v2ray/privoxy/config:/etc/privoxy/config

    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    ports:
      - "8118:8118"  # 经过privoxy 处理后的http代理端口，可以去广告，自动路由等功能
      - "1088:1088"  #socket 代理端口
      - "1089:1089"  #http 代理端口
    restart: always
```

v2ray config中部分配置，和上面compose 文件对应端口
```
    {
      "tag": "socks",
      "port": 1088,
      "listen": "0.0.0.0",
      "protocol": "socks",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "settings": {
        "auth": "noauth",
        "udp": true,
        "allowTransparent": false
      }
    },
    {
      "tag": "http",
      "port": 1089,
      "listen": "0.0.0.0",
      "protocol": "http",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
```
