Host *
  IPQoS=throughput

# Make GitHub work on coffee shops that block SSH
# See https://stackoverflow.com/questions/7953806/github-ssh-via-public-wifi-port-22-blocked
Host github.com
  Hostname ssh.github.com
  Port 443
  # https://github.blog/2021-09-01-improving-git-protocol-security-github/
  UpdateHostKeys yes

%%ifeq OS darwin
# Load ssh/id_rsa from the keychain by default
# See https://apple.stackexchange.com/a/250572
Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
%%endif