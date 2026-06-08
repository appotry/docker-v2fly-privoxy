# docker-v2fly-privoxy

> 基于 Alpine 的 Docker 镜像，集成 v2fly/v2ray-core + privoxy + 自动生成的 GFW 路由规则。入口脚本先启动 privoxy，后启动 v2ray。

## 命令

| 命令 | 作用 |
|------|------|
| `docker build -t bloodstar/v2fly-privoxy:latest .` | 单架构本地构建 |
| `docker buildx build --platform linux/amd64,linux/386,linux/arm/v6,linux/arm/v7,linux/arm64 -t bloodstar/v2fly-privoxy:latest .` | 多架构构建 |
| `docker run -dti -p 8118:8118 -v /path/to/config.json:/etc/v2ray/config.json bloodstar/v2fly-privoxy` | 运行（挂载 v2ray 配置） |

## 项目结构

```
├── Dockerfile           # 多阶段构建：（1）Alpine + glibc + gfwlist 生成（2）v2fly-core + privoxy
├── entrypoint.sh        # 容器入口：privoxy → v2ray
├── renovate.json        # Renovate 依赖更新配置
├── opencode.json        # OpenCode 项目配置
├── AGENTS.md            # AI 工作约定（当前文件）
├── README.md            # 用户文档（中文）
├── docs/
│   ├── STRUCTURE.md     # 项目文件清单
│   └── ARCHITECTURE.md  # 架构说明、构建流水线、数据流
└── .github/
└── workflows/
        └── Build Image.yml  # GitHub Actions：版本检测 → 构建 → 推送
```

## 关键细节

- v2ray 配置中的 socks 端口**必须**与 `gfwlist.action` 目标一致（默认 `127.0.0.1:1088`）
- v2ray 配置文件必须挂载到 `/etc/v2ray/config.json`
- 自定义 privoxy 配置可挂载到 `/etc/privoxy/config`
- 构建时 privoxy 被设为 `listen-address 0.0.0.0:8118`，追加 `gfwlist.action`


## CI / Docker

`.github/workflows/Build Image.yml`：
- **On push** 到 `main`/`master` — 始终构建（捕获 Dockerfile 变更）
- **每日 06:00 UTC** — 自动构建（确保最新 gfwlist）
- **手动触发** — 同上
- Tag 格式：`<v2fly-core-version>` + `latest`（例如 `bloodstar/v2fly-privoxy:v5.41.0`）
- 版本由工作流自动检测：查询 Docker Hub API 获取 `v2fly/v2fly-core` 最新 semver 标签

## 工程化约定

### Git 提交规范

```
type(scope): 简短描述（50 字以内）
```

| type | emoji | 用途 |
|------|-------|------|
| feat | ✨ | 新功能 |
| fix | 🐛 | Bug 修复 |
| docs | 📖 | 文档变更 |
| refactor | ♻️ | 代码重构 |
| perf | ⚡ | 性能优化 |
| test | 🧪 | 测试相关 |
| ci | 👷 | CI/CD 配置 |
| chore | 🔧 | 构建/工具/配置 |
| style | 🎨 | 代码格式 |

- 小提交：每提交只做一件事
- 提交前运行构建验证

### 编码规范

- 缩进：2 空格
- 编码：UTF-8
- 交流语言：中文
- 思考语言：中文
- 变量/函数命名：英文（camelCase）

### 沟通约定

- 所有交流使用中文
- 回答简洁直接，不超过 4 行正文
- 不需要开场白和结束语
- 引用文件格式：`路径:行号`
- 关键操作前询问确认
- 修改前先读文件

## 文档导航

| 文档 | 适用角色 | 内容 |
|------|----------|------|
| `README.md` | 用户 | 项目简介、快速开始、使用说明 |
| `AGENTS.md` | AI / 开发者 | 工程化约定、命令、关键细节（当前文件） |
| `docs/STRUCTURE.md` | 开发者 | 项目文件清单、各文件职责 |
| `docs/ARCHITECTURE.md` | 开发者 | 构建流水线、运行时数据流、设计决策 |

## 经验知识库

<!-- Skill: dev-experience（自动加载，网关路径 `~/.agents/skills/dev-experience/SKILL.md`） -->

本项目类型标签：`docker`、`ci-cd`、`network`、`devops`、`mirror`、`dependabot`

Agent 通过 Skill 网关自动读取 `INDEX.md` 标签索引和 `MAP.md` 场景路径，无需手动管理引用路径。已绑定到 `~/Work/dev-experience/projects/docker-v2fly-privoxy/`。
