# Set default values for all following accounts.
defaults
auth           on
tls            on

# msmtp complains with "empty reply from server"
# if this setting is on
# Off means "tunnel the session through TLS"
# See http://msmtp.sourceforge.net/doc/msmtp.html
tls_starttls   off

%%ifeq OS macos
%%ifeq ARCH arm64
tls_trust_file /opt/homebrew/etc/openssl@1.1/cert.pem
%%else
tls_trust_file /usr/local/etc/openssl@1.1/cert.pem
%%endif
%%else
tls_trust_file /usr/local/etc/openssl@1.1/cert.pem
%%endif
logfile        ~/.msmtp.log

# Mailfence
account        mailfence
host           smtp.mailfence.com
port           465
from           jv@jviotti.com
user           jviotti
passwordeval   "pass key personal/mailfence.com"

# Postman
account        postman
host           smtp.gmail.com
port           465
from           juan.viotti@postman.com
user           juan.viotti@postman.com
passwordeval   "pass key work/postman/gmail.com"

# Intelligence
account        intelligence
host           smtp.gmail.com
port           465
from           juan@intelligence.ai
user           juan@intelligence.ai
passwordeval   "pass key intelligence.ai/jviotti/gmail.com"

# Set a default account
account default : mailfence
