#################################################
# Mailfence
#################################################

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

#################################################
# Postman
#################################################

IMAPAccount postman
Host imap.gmail.com
User juan.viotti@postman.com
PassCmd +"pass key work/postman/gmail.com"
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

IMAPStore postman-remote
Account postman

MaildirStore postman-local
Path ~/Mail/Postman/
Inbox ~/Mail/Postman/INBOX

Channel postman-inbox
Far :postman-remote:
Near :postman-local:
Patterns "INBOX"
Create Both
Expunge Both
SyncState *

Channel postman-trash
Far :postman-remote:"[Gmail]/Trash"
Near :postman-local:Trash
Create Both
Expunge Both
SyncState *

Group postman
Channel postman-inbox
Channel postman-trash
