#################################################
# Proton
#################################################

IMAPAccount proton-bridge
Host 127.0.0.1
Port 1143
User jv@jviotti.com
PassCmd +"pass key personal/proton.me/imap"
AuthMechs LOGIN
TLSType STARTTLS
# Extract using:
# openssl s_client -starttls imap -connect 127.0.0.1:1143 -showcerts
# See https://stackoverflow.com/a/57789973
CertificateFile ~/.config/protonmail/bridge/cert.pem

IMAPStore proton-bridge-remote
Account proton-bridge

MaildirStore proton-bridge-local
Path ~/Mail/Personal/
Inbox ~/Mail/Personal/INBOX

Channel proton-bridge-all
Far :proton-bridge-remote:
Near :proton-bridge-local:
Patterns INBOX Archive Drafts Trash Sent Spam
Create Both
Expunge Both
SyncState *

Group proton-bridge
Channel proton-bridge-all
