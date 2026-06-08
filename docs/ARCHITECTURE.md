# 架构说明

## 构建流水线

```
                    Docker Hub
                   /          \
    v2fly/v2fly-core       alpine:latest
          |                      |
          |  (第二阶段)           |  (第一阶段 — 构建)
          v                      v
       v2fly-core 基础       glibc + gfwlist2privoxy
          |                      |
          |  + privoxy           |
          |  + gfwlist.action    |
          \                      /
           \                    /
            v                  v
          bloodstar/v2fly-privoxy
```

### 第一阶段（alpine）

- 安装 bash、ca-certificates、curl、perl
- 通过 `gfwlist2privoxy` 生成 `gfwlist.action`，目标地址 `127.0.0.1:1088`

### 第二阶段（v2fly/v2fly-core）

- 安装 privoxy
- 从第一阶段复制 gfwlist.action
- 修改 privoxy 配置：设置 `listen-address 0.0.0.0:8118`，追加 `actionsfile gfwlist.action`

## 运行时数据流

```
浏览器 / 应用 ──HTTP──> privoxy (:8118) ──socks5──> v2ray (:1088) ──> 互联网
                             │
                         gfwlist.action
                        (自动路由规则)
```

- **privoxy** 监听 `0.0.0.0:8118`，通过 socks5 转发到 v2ray
- **v2ray** 读取绑定挂载的 `/etc/v2ray/config.json`
- v2ray 配置中的 socks 端口**必须**与 gfwlist.action 目标一致

## 版本检测机制

版本检测由 Dependabot（`.github/dependabot.yml`）每日自动完成：

1. Dependabot 扫描 `Dockerfile` 中 `FROM v2fly/v2fly-core:<version>` 的固定版本号
2. 比对 Docker Hub 上 `v2fly/v2fly-core` 的最新标签
3. 检测到新版本时，自动提 PR 更新 Dockerfile 中的版本号
4. PR 合并到 `main`/`master` 后，push 触发 CI 构建

CI 工作流从 Dockerfile 的 `FROM` 行提取版本号作为镜像 tag。
