# docker-claw 🐱

OpenClaw in a Docker container. SSH接続でOpenClawを利用できるにゃん。

## セットアップ

```bash
git clone git@github.com:icethink/docker-claw.git
cd docker-claw

# SSH公開鍵を配置
cp ~/.ssh/id_ed25519.pub data/authorized_keys

# ボリュームが必要なら docker-compose.yml を編集

docker compose build
docker compose up -d
```

## SSH接続

```bash
ssh -i ~/.ssh/id_ed25519 -p 2222 openclaw@localhost
```

## ボリューム

`docker-compose.yml` で設定:

| パス | 説明 |
|------|------|
| `./data/openclaw-config` | OpenClaw設定（読み書き） |
| `./data/ssh-host-keys` | SSHホスト鍵の永続化 |
| `./data/authorized_keys` | SSH公開鍵（読み取り専用） |

### ボリューム追加

`docker-compose.yml` の volumes セクションに追記:
```yaml
volumes:
  # 読み取り専用
  - /host/path:/mnt/data:ro
  # 読み書き可
  - /host/path:/mnt/shared
```

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
