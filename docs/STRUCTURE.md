# 项目文件清单

## 根级文件

| 文件 | 用途 |
|------|------|
| `Dockerfile` | 多阶段构建：（1）Alpine + glibc + gfwlist 生成（2）v2fly-core + privoxy |
| `entrypoint.sh` | 容器 ENTRYPOINT：先启动 privoxy，再启动 v2ray |
| `renovate.json` | Renovate 依赖更新配置 |
| `opencode.json` | OpenCode 项目配置 |

## CI / 自动化

| 文件 | 用途 |
|------|------|
| `.github/workflows/Build Image.yml` | GitHub Actions：push 触发 → 构建 → 推送 |
| `.github/dependabot.yml` | Dependabot Docker 基础镜像更新 |

## 文档

| 文件 | 用途 |
|------|------|
| `AGENTS.md` | AI 工作约定 — 首选入口 |
| `README.md` | 用户使用指南（中文） |
| `docs/ARCHITECTURE.md` | 架构说明、构建流水线、运行时数据流 |
| `docs/STRUCTURE.md` | 当前文件 — 项目文件清单 |
