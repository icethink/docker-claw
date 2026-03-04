FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    openssh-server \
    sudo \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22.x
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw

# Create openclaw user with sudo nopasswd
RUN useradd -m -s /bin/bash openclaw \
    && echo 'openclaw ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/openclaw \
    && chmod 0440 /etc/sudoers.d/openclaw

# Setup SSH
RUN mkdir /var/run/sshd \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Prepare SSH directory for openclaw user
RUN mkdir -p /home/openclaw/.ssh \
    && chmod 700 /home/openclaw/.ssh \
    && chown openclaw:openclaw /home/openclaw/.ssh

# Prepare OpenClaw directories
RUN mkdir -p /home/openclaw/.openclaw/workspace \
    && chown -R openclaw:openclaw /home/openclaw/.openclaw

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
