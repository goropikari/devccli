```bash
devcontainer up \
    --workspace-folder=. \
    --additional-features='{"ghcr.io/goropikari/devcontainer-feature/socat:1": {},"ghcr.io/goropikari/devcontainer-feature/neovim:1": {}, "ghcr.io/devcontainers/features/sshd:1": {}}'
container_id=$(devcontainer up --workspace-folder=. | tail -n1 | jq -r .containerId)
container_hostname=$(docker inspect $container_id --format='{{.Config.Hostname}}')
ip_address=$(docker inspect $container_hostname --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
devcontainer exec --workspace-folder=. mkdir -p /home/vscode/.ssh
docker cp ~/.ssh/id_rsa.pub $container_id:/home/vscode/.ssh/authorized_keys
devcontainer exec --workspace-folder=. bash -c 'chmod 644 /home/vscode/.ssh/authorized_keys'
devcontainer exec --workspace-folder=. bash -c 'chmod 700 /home/vscode/.ssh'

# option
# echo 'ForwardAgent yes' >> ~/.ssh/config
socat tcp-listen:2222,fork tcp-connect:$ip_address:2222 &
ssh -t -i ~/.ssh/id_rsa -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -p 2222 vscode@localhost
```
