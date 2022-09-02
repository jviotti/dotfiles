IMAPAccount personal
Host imap.mailfence.com
User jv@jviotti.com
PassCmd +"pass key personal/mailfence.com"
AuthMechs LOGIN
SSLType IMAPS
%%ifeq OS macos
%%ifeq ARCH arm64
CertificateFile /opt/homebrew/etc/openssl@1.1/cert.pem
%%else
CertificateFile /usr/local/etc/openssl@1.1/cert.pem
%%endif
%%else
%%endif

IMAPStore personal-remote
Account personal

MaildirStore personal-local
Path ~/Mail/Personal/
Inbox ~/Mail/Personal/INBOX

Channel personal-all
%%ifeq OS linux
Master :personal-remote:
Slave :personal-local:
%%else
Far :personal-remote:
Near :personal-local:
%%endif
Patterns *
Create Both
Expunge Both
SyncState *

Group personal
Channel personal-all
