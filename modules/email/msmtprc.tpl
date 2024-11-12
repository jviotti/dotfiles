# Set default values for all following accounts.
defaults
auth           on
tls            on
logfile        ~/.msmtp.log

# Proton
account        proton
host           127.0.0.1
port           1025
from           jv@jviotti.com
user           jv@jviotti.com
passwordeval   "pass key personal/proton.me/smtp"
# Off means "tunnel the session through TLS"
# See http://msmtp.sourceforge.net/doc/msmtp.html
tls_starttls   off
# Extract using:
# openssl s_client -starttls imap -connect 127.0.0.1:1143 -showcerts
# See https://stackoverflow.com/a/57789973
tls_trust_file ~/.config/protonmail/bridge/cert.pem

# Set a default account
account default : proton
