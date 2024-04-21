```bash
docker network create hoge-network
devcontainer up \
    --workspace-folder=. \
    --additional-features='{"ghcr.io/goropikari/devcontainer-feature/socat:1": {},"ghcr.io/goropikari/devcontainer-feature/neovim:1": {}, "ghcr.io/devcontainers/features/sshd:1": {}}'
container_id=$(devcontainer up --workspace-folder=. | tail -n1 | jq -r .containerId)
container_hostname=$(docker inspect $container_id --format='{{.Config.Hostname}}')
ip_address=$(docker inspect $container_hostname --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
devcontainer exec --workspace-folder=. bash -c 'mkdir -p /home/vscode/.ssh'
docker cp ~/.ssh/id_rsa.pub $container_id:/home/vscode/.ssh/authorized_keys
devcontainer exec --workspace-folder=. bash -c 'chmod 644 /home/vscode/.ssh/authorized_keys'
devcontainer exec --workspace-folder=. bash -c 'chmod 700 /home/vscode/.ssh'

# option
# echo 'ForwardAgent yes' >> ~/.ssh/config
ssh -t -i ~/.ssh/id_rsa -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -p 2222 vscode@$ip_address
```

```bash
docker network create hoge-network
AUTH_SOCK=/tmp/ssh_auth_sock
ln -f $SSH_AUTH_SOCK $AUTH_SOCK
devcontainer up \
    --workspace-folder=. \
    --mount "type=bind,source=$AUTH_SOCK,target=$AUTH_SOCK" \
    --additional-features='{"ghcr.io/goropikari/devcontainer-feature/socat:1": {},"ghcr.io/goropikari/devcontainer-feature/neovim:1": {}, "ghcr.io/devcontainers/features/sshd:1": {}}'
container_id=$(devcontainer up --workspace-folder=. | tail -n1 | jq -r .containerId)
container_hostname=$(docker inspect $container_id --format='{{.Config.Hostname}}')
ip_address=$(docker inspect $container_hostname --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
devcontainer exec --workspace-folder=. bash -c 'mkdir -p /home/vscode/.ssh'
docker cp ~/.ssh/id_rsa.pub $container_id:/home/vscode/.ssh/authorized_keys
devcontainer exec --workspace-folder=. bash -c 'chmod 644 /home/vscode/.ssh/authorized_keys'
devcontainer exec --workspace-folder=. bash -c 'chmod 700 /home/vscode/.ssh'

# option
# echo 'ForwardAgent yes' >> ~/.ssh/config
ssh -t -i ~/.ssh/id_rsa -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -p 2222 vscode@$ip_address
```
