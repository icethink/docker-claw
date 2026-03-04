#!/bin/bash
set -e

# Fix SSH authorized_keys permissions
if [ -f /home/openclaw/.ssh/authorized_keys ]; then
    chmod 600 /home/openclaw/.ssh/authorized_keys
    chown openclaw:openclaw /home/openclaw/.ssh/authorized_keys
fi

# Persist SSH host keys
HOST_KEY_DIR="/etc/ssh/host_keys"
if [ -d "$HOST_KEY_DIR" ]; then
    if ls "$HOST_KEY_DIR"/ssh_host_* 1>/dev/null 2>&1; then
        cp "$HOST_KEY_DIR"/ssh_host_* /etc/ssh/
    else
        ssh-keygen -A
        cp /etc/ssh/ssh_host_* "$HOST_KEY_DIR/"
    fi
else
    ssh-keygen -A
fi

# Ensure correct ownership
chown -R openclaw:openclaw /home/openclaw/.openclaw 2>/dev/null || true
su - openclaw -c "mkdir -p /home/openclaw/.openclaw/workspace" 2>/dev/null || true

echo "=== docker-claw ==="
echo "SSH server starting on port 22"
echo "User: openclaw"
echo "=================="

exec /usr/sbin/sshd -D
