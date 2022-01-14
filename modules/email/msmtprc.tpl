# Set default values for all following accounts.
defaults
auth           on
tls            on

# msmtp complains with "empty reply from server"
# if this setting is on
# Off means "tunnel the session through TLS"
# See http://msmtp.sourceforge.net/doc/msmtp.html
tls_starttls   off

%%ifeq OS darwin
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

# Oxford
account        oxford
host           smtp.ox.ac.uk
port           587
from           juancruz.viotti@kellogg.ox.ac.uk
user           kell4769
passwordeval   "pass key education/sso.ox.ac.uk"
tls_starttls   on

# Postman
account        postman
host           smtp.gmail.com
port           465
from           juan.viotti@postman.com
user           juan.viotti@postman.com
passwordeval   "pass key work/postman/gmail.com"

# Set a default account
account default : mailfence
