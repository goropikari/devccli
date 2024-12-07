```bash
devcontainer up \
    --workspace-folder=. \
    --additional-features='{"ghcr.io/goropikari/devcontainer-feature/socat:1": {},"ghcr.io/goropikari/devcontainer-feature/neovim:1": {}, "ghcr.io/devcontainers/features/sshd:1": {}}' \
    --include-configuration=true \
    --include-merged-configuration=true \
    --remove-existing-container
container_id=$(devcontainer up --workspace-folder=. | tail -n1 | jq -r .containerId)
docker rename $container_id devc
container_hostname=$(docker inspect devc --format='{{.Config.Hostname}}')
ip_address=$(docker inspect devc --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
devcontainer exec --workspace-folder=. mkdir -p /home/vscode/.ssh
docker cp ~/.ssh/id_rsa.pub devc:/home/vscode/.ssh/authorized_keys
devcontainer exec --workspace-folder=. bash -c 'chmod 644 /home/vscode/.ssh/authorized_keys'
devcontainer exec --workspace-folder=. bash -c 'chmod 700 /home/vscode/.ssh'

ssh -t -i ~/.ssh/id_rsa -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 2222 vscode@devc
ssh-keyscan github.com > ~/.ssh/known_hosts
ssh -T git@gihub.com
```

```ssh
ForwardAgent yes

Host devc
    ProxyCommand /usr/bin/nc $(docker inspect devc --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}') %p
    Port 2222
    User vscode
    NoHostAuthenticationForLocalhost yes
    UserKnownHostsFile /dev/null
    GlobalKnownHostsFile /dev/null
    StrictHostKeyChecking no
```

```bash
ssh devc
```
