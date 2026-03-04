# docker-claw 🐱

OpenClaw in a Docker container. SSH接続でOpenClawを利用できるにゃん。

## セットアップ

```bash
git clone git@github.com:icethink/docker-claw.git
cd docker-claw
cp .env.example .env
# .env を編集（SSH公開鍵を設定）
docker compose build
docker compose up -d
```

## SSH接続

```bash
ssh -i ~/.ssh/your_key -p 2222 openclaw@localhost
```

## .env 設定項目

| 変数 | 説明 | デフォルト |
|------|------|-----------|
| `SSH_PORT` | ホストに公開するSSHポート | `2222` |
| `SSH_AUTHORIZED_KEYS` | SSH公開鍵 | - |
| `RW_OPENCLAW_CONFIG` | OpenClaw設定ディレクトリ（読み書き可） | `./data/openclaw-config` |
| `RO_VOLUME_1` | ホスト共有ディレクトリ（読み取り専用、コンテナ内 `/mnt/shared`） | `./data/readonly` |
| `RW_SSH_HOST_KEYS` | SSHホスト鍵の永続化 | `./data/ssh-host-keys` |

## コンテナ内

- **ユーザー:** `openclaw`
- **sudo:** パスワードなしで利用可能
- **OpenClaw:** グローバルインストール済み
- **Node.js:** v22.x

## OpenClaw初期設定

SSH接続後:
```bash
openclaw doctor
```

## ボリューム追加

`docker-compose.yml` に追加のボリュームを記載:
```yaml
volumes:
  - /host/path:/mnt/custom-name:ro   # 読み取り専用
  - /host/path:/mnt/custom-name      # 読み書き可
```
