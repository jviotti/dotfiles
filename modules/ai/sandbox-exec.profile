;; ---------------------------------------------------------------------------
;; Claude Code sandbox-exec profile
;; Deny-by-default kernel sandbox for running Claude Code on macOS.
;; Modeled on Agent Safehouse (eugene1g/agent-safehouse) and Claudebox
;; (Greitas-Kodas/claudebox).
;;
;; Usage:
;;   sandbox-exec -f ~/.claude/sandbox-exec.profile claude --dangerously-skip-permissions
;;
;; Security model:
;;   - Deny all access by default (principle of least privilege)
;;   - Read-only access to system paths and toolchains
;;   - Read/write access to Claude state, temp dirs, and the project workdir
;;   - Sensitive directories (~/.ssh keys, ~/.aws, ~/.gnupg) are blocked
;;   - Network is fully open (use an external firewall for domain filtering)
;;
;; The project workdir is NOT granted here. The safeclaude wrapper appends
;; workdir grants for the current directory at launch time.
;; ---------------------------------------------------------------------------

(version 1)

;; Home directory helper macros, following Agent Safehouse convention.
;; These let us write (home-subpath "/foo") instead of repeating the full
;; home path everywhere, making the profile portable across machines.
;;
;; HOME_DIR is injected by the safeclaude wrapper at launch time via:
;;   (define HOME_DIR "/Users/whoever")
;; It must be defined before this file is evaluated.

(define (home-subpath rel) (subpath (string-append HOME_DIR rel)))
(define (home-literal rel) (literal (string-append HOME_DIR rel)))
(define (home-prefix rel) (prefix (string-append HOME_DIR rel)))

;; Start from deny-everything. Every permission below is an explicit opt-in.
(deny default)


;; ===========================================================================
;; System Runtime (read-only)
;;
;; Core OS paths that virtually every process needs to start and run.
;; Without these, even /usr/bin/true will fail (exit 134 / SIGABRT).
;; ===========================================================================

(allow file-read*
    ;; Root directory listing. Required for path traversal into top-level
    ;; directories. Without this, processes abort on startup because the
    ;; dynamic linker cannot resolve paths.
    (literal "/")

    ;; Core UNIX system directories (binaries, libraries, headers)
    (subpath "/usr")
    (subpath "/bin")
    (subpath "/sbin")

    ;; /opt is the Homebrew install root on Apple Silicon. Granted broadly
    ;; here because many tools live under /opt/homebrew/bin and need their
    ;; dylibs from /opt/homebrew/lib.
    (subpath "/opt")

    ;; macOS system frameworks and runtime resources. Required by dyld for
    ;; loading system libraries and by most CLIs for basic functionality.
    (subpath "/System/Library")

    ;; Some dyld/framework lookups resolve through Preboot symlinks on
    ;; modern APFS-volume macOS.
    (subpath "/System/Volumes/Preboot")

    ;; Apple private frameworks loaded by Node, Bun, JVM, and native toolchains
    (subpath "/Library/Apple")

    ;; Global framework lookup path for language runtimes and CLIs
    (subpath "/Library/Frameworks")

    ;; Font reads used by headless renderers, PDF tasks, and image processing
    (subpath "/Library/Fonts")

    ;; Path resolution may load NetFS plugins during filesystem lookups
    (subpath "/Library/Filesystems/NetFSPlugins")

    ;; macOS logging stack reads prefs during process initialization
    (subpath "/Library/Preferences/Logging")

    ;; Locale, timezone, and user defaults queried by language runtimes
    (literal "/Library/Preferences/.GlobalPreferences.plist")

    ;; DNS/network bootstrap reads networkd configuration
    (literal "/Library/Preferences/com.apple.networkd.plist")

    ;; /dev directory listing needed by shells during initialization
    (literal "/dev")
)

;; Metadata-only traversal (stat/readdir, no content reads) needed during
;; binary/framework path resolution and socket namespace discovery
(allow file-read-metadata
    (subpath "/System")
    (subpath "/private/var/run")
)

;; /etc and /var are symlinks into /private/* on macOS. These grants cover
;; the real paths that system tools resolve through those symlinks.
(allow file-read*
    ;; Required for symlink traversal under the macOS /private namespace
    (literal "/private")
    (literal "/private/var")

    ;; Timezone database, used by language date/time formatting
    (subpath "/private/var/db/timezone")

    ;; /bin/sh selector used by macOS shell launch behavior
    (literal "/private/var/select/sh")

    ;; xcode-select developer dir pointer, used by build CLIs to find the
    ;; active Xcode or Command Line Tools installation
    (literal "/private/var/select/developer_dir")
    (literal "/var/select/developer_dir")
    (literal "/private/var/db/xcode_select_link")
    (literal "/var/db/xcode_select_link")

    ;; Network configuration files used by the resolver stack
    (literal "/private/etc/hosts")
    (literal "/private/etc/resolv.conf")
    (literal "/private/etc/services")
    (literal "/private/etc/protocols")

    ;; Valid shell list read by shell/auth tooling
    (literal "/private/etc/shells")

    ;; TLS CA bundles and certificates used by HTTP and package manager clients
    (subpath "/private/etc/ssl")

    ;; Localtime symlink read by date/time libraries
    (literal "/private/etc/localtime")

    ;; Compatibility symlink roots for tools that hardcode /etc or /var
    (literal "/etc")
    (literal "/var")
)

;; Metadata-only traversal for XDG/home probe paths used by CLI tools during
;; startup. Many tools (mise, gh, git, etc.) stat these directories before
;; deciding whether to read config from them.
(allow file-read-metadata
    (literal "/home")
    (literal "/Users")
    (literal HOME_DIR)
    (literal "/private/etc")
    (subpath "/dev")
    (home-literal "/.config")
    (home-literal "/.cache")
    (home-literal "/.local")
    (home-literal "/.local/share")
)

;; User-level preferences and encoding settings read by frameworks and CLIs
;; at startup. These are read-only.
(allow file-read*
    ;; User locale/defaults plist variants read by many frameworks
    (home-prefix "/Library/Preferences/.GlobalPreferences")
    (home-prefix "/Library/Preferences/com.apple.GlobalPreferences")

    ;; Per-host preferences read by security CLI and system frameworks
    (home-subpath "/Library/Preferences/ByHost")

    ;; User text encoding prefs, read by many processes for correct
    ;; string handling
    (home-literal "/.CFUserTextEncoding")

    ;; XDG config/cache root directory listing for tool discovery
    (home-literal "/.config")
    (home-literal "/.cache")

    ;; PATH probing may readdir ~/.local/bin before spawning user-installed
    ;; helpers
    (home-literal "/.local/bin")
)


;; ===========================================================================
;; Process execution, forking, signals
;;
;; Agent workflows chain many subprocesses (shells, compilers, test runners,
;; git, package managers). These broad process primitives are required for
;; that to work.
;; ===========================================================================

;; Allow executing any binary. The file-read* grants above control which
;; binaries are actually reachable. This is intentionally unfiltered because
;; Claude spawns a wide variety of tools.
(allow process-exec)

;; Required for normal child-process trees in CLI agents
(allow process-fork)

;; Runtime/process introspection used by many CLIs at startup
(allow sysctl-read)

;; Allow process introspection and signalling within the same sandbox.
;; Needed for Claude to manage its own child processes (cancellation,
;; cleanup, etc.) without being able to inspect or signal other users'
;; processes.
(allow process-info* (target same-sandbox))
(allow signal (target same-sandbox))
(allow mach-priv-task-port (target same-sandbox))

;; Required for interactive terminal sessions and PTY allocation
(allow pseudo-tty)


;; ===========================================================================
;; Temp directories
;;
;; Subprocesses, package managers, and compilers all write transient files
;; and IPC sockets to temp directories. Both the /tmp symlink and the real
;; /private/tmp path are needed, plus the per-user temp/cache roots under
;; /var/folders.
;; ===========================================================================

(allow file-read* file-write*
    (subpath "/tmp")
    (subpath "/private/tmp")
    (subpath "/var/folders")
    (subpath "/private/var/folders")
)

;; Defense-in-depth: block launchd-managed per-user listener sockets that
;; live in /tmp. These are used by SSH agent, pasteboard, etc. and are
;; selectively re-opened in the SSH section below where needed.
(deny file-read* file-write*
    (regex #"^/private/tmp/com\.apple\.launchd\.[^/]+/Listeners$")
    (regex #"^/tmp/com\.apple\.launchd\.[^/]+/Listeners$")
)


;; ===========================================================================
;; Device nodes
;;
;; Terminal devices, PTYs, and descriptor plumbing needed for shell I/O
;; in CLI agent terminal workflows.
;; ===========================================================================

;; Read/write access to terminal and PTY devices for interactive I/O
(allow file-read* file-write*
    ;; Process substitution and file-descriptor access (bash <(...), /dev/fd/N)
    (subpath "/dev/fd")
    (literal "/dev/stdout")
    (literal "/dev/stderr")
    (literal "/dev/null")
    ;; Controlling terminal device for interactive sessions
    (literal "/dev/tty")
    ;; PTY multiplexer required for pseudo-terminal allocation
    (literal "/dev/ptmx")
    ;; DTrace compatibility for dyld/runtime startup probes
    (literal "/dev/dtracehelper")
    ;; Dynamic tty/pty device names created for terminal sessions
    (regex #"^/dev/tty")
    (regex #"^/dev/ttys")
    (regex #"^/dev/pty")
)

;; Read-only entropy and system probe devices touched by many runtimes
(allow file-read*
    ;; Zero-filled source used by some runtimes/tests
    (literal "/dev/zero")
    ;; Automount readiness check probed by most CLI processes at startup
    (literal "/dev/autofs_nowait")
    ;; DTrace helper probed by dyld at process start
    (literal "/dev/dtracehelper")
    ;; Entropy sources used by crypto/token generation
    (literal "/dev/urandom")
    (literal "/dev/random")
)

;; Terminal I/O control (ioctl) needed for TTY mode/attribute operations
(allow file-ioctl
    (literal "/dev/dtracehelper")
    (literal "/dev/tty")
    (literal "/dev/ptmx")
    (regex #"^/dev/tty")
    (regex #"^/dev/ttys")
    (regex #"^/dev/pty")
)


;; ===========================================================================
;; Mach IPC services (baseline)
;;
;; These are macOS system services commonly needed by CLI runtimes for
;; logging, DNS, trust evaluation, file events, and identity lookups.
;; Without these, many basic operations (network requests, file watching,
;; process spawning) fail silently or with cryptic errors.
;; ===========================================================================

(allow mach-lookup
    ;; Notification center lookup done by some CLIs
    (global-name "com.apple.system.notification_center")
    ;; User/group resolution via opendirectory (getpwnam, etc.)
    (global-name "com.apple.system.opendirectoryd.libinfo")
    ;; Unified logging backend used by system frameworks
    (global-name "com.apple.logd")
    ;; File event stream access used by file watchers (FSEvents)
    (global-name "com.apple.FSEvents")
    ;; System network/config queries for resolver bootstrap
    (global-name "com.apple.SystemConfiguration.configd")
    ;; DNS configuration XPC dependency used by Node/c-ares
    (global-name "com.apple.SystemConfiguration.DNSConfiguration")
    ;; TLS certificate trust evaluation for HTTPS connections
    (global-name "com.apple.trustd.agent")
    ;; Unified logging diagnosticd backend
    (global-name "com.apple.diagnosticd")
    ;; Analytics subsystem queried during runtime initialization
    (global-name "com.apple.analyticsd")
    ;; DNS-SD (Bonjour) service used for DNS resolution by ssh, curl, etc.
    (global-name "com.apple.dnssd.service")
    ;; Core Services daemon for UTI type resolution and file type identification
    (global-name "com.apple.CoreServices.coreservicesd")
    ;; Disk metadata queries probed by some frameworks during init
    (global-name "com.apple.DiskArbitration.diskarbitrationd")
    ;; Analytics message tracer probed by frameworks during init
    (global-name "com.apple.analyticsd.messagetracer")
    ;; Legacy system logger endpoint used by some CLIs
    (global-name "com.apple.system.logger")
    ;; Launch Services daemon for app registration and UTI resolution
    (global-name "com.apple.coreservices.launchservicesd")
    ;; Preference daemon used by cfprefsd-backed preference reads. Required
    ;; by xcodebuild, xcrun, and other Apple tools that read plists via the
    ;; CFPreferences API (e.g. Xcode license acceptance state).
    (global-name "com.apple.cfprefsd.daemon")
    (global-name "com.apple.cfprefsd.agent")
)

;; AF_SYSTEM sockets used by network stack for kernel event monitoring
(allow system-socket)

;; Notification center shared memory segment read by system frameworks
(allow ipc-posix-shm-read-data
    (ipc-posix-name "apple.shm.notification_center")
)


;; ===========================================================================
;; Launch Services (for the `open` command)
;;
;; Needed so that `open` can resolve file type associations and actually
;; launch the target application.
;; ===========================================================================

(allow mach-lookup
    ;; Read-only type-to-app mapping database
    (global-name "com.apple.lsd.mapdb")
    ;; Writeable mapping database (required even for read-only `open` calls)
    (global-name "com.apple.lsd.modifydb")
    ;; Gatekeeper quarantine check before launching an app
    (global-name "com.apple.coreservices.quarantine-resolver")
)

;; When `open` hands a path to the target app, it issues a sandbox extension
;; so the launched app can access the file/folder
(allow file-issue-extension
    (extension-class "com.apple.app-sandbox.read")
    (extension-class "com.apple.app-sandbox.read-write")
)

;; Kernel-level Launch Services call that opens a file/folder/URL
(allow lsopen)


;; ===========================================================================
;; Network (fully open)
;;
;; Intentionally allows all network access. Blocking exfiltration is NOT a
;; goal of this sandbox. The goal is reliable agent operation: package
;; installs (npm, brew), API calls (Anthropic, GitHub), web fetches, and
;; localhost dev servers all need network.
;;
;; For domain-level restrictions, use an external firewall (Little Snitch,
;; Lulu, pfctl).
;; ===========================================================================

(allow network*)


;; ===========================================================================
;; Claude Code state and configuration
;;
;; Claude stores authentication tokens, conversation state, settings, and
;; MCP configuration across several directories. The installer-managed
;; binary lives under ~/.local/bin/claude and ~/.local/share/claude.
;; ===========================================================================

(allow file-read* file-write*
    ;; Claude CLI binary symlink and version-specific targets
    (home-prefix "/.local/bin/claude")
    ;; CLI cache (conversation state, tool results, etc.)
    (home-subpath "/.cache/claude")
    ;; Primary Claude config directory (~/.claude/)
    (home-subpath "/.claude")
    ;; Settings file and variants
    (home-prefix "/.claude.json")
    ;; Lock file for concurrent access
    (home-literal "/.claude.lock")
    ;; XDG-style config
    (home-subpath "/.config/claude")
    ;; XDG-style state and data
    (home-subpath "/.local/state/claude")
    (home-subpath "/.local/share/claude")
    ;; MCP (Model Context Protocol) server configuration
    (home-literal "/.mcp.json")
)

;; Read-only access to managed/system-level Claude configuration
(allow file-read*
    ;; Suffixed settings file variants
    (home-prefix "/.claude.json.")
    ;; Claude Desktop MCP import source
    (home-literal "/Library/Application Support/Claude/claude_desktop_config.json")
    ;; Organization-managed policy files
    (subpath "/Library/Application Support/ClaudeCode/.claude")
    (literal "/Library/Application Support/ClaudeCode/managed-settings.json")
    (literal "/Library/Application Support/ClaudeCode/managed-mcp.json")
    (literal "/Library/Application Support/ClaudeCode/CLAUDE.md")
)


;; ===========================================================================
;; Shared agent context
;;
;; Skills, agents, and guidance files shared across different AI coding
;; tools. These conventions come from the Agent Safehouse ecosystem.
;; ===========================================================================

(allow file-read* file-write*
    ;; Shared skill instructions/scripts that agents may read or update
    (home-subpath "/.skills")
    ;; Agent config/skills directory
    (home-subpath "/.agents")
    ;; Shared agent policy/instructions file
    (home-literal "/AGENTS.md")
)

(allow file-read*
    ;; Cross-agent convention: shared Claude agents and skills directories
    (home-subpath "/.claude/agents")
    (home-subpath "/.claude/skills")
    ;; Repository/user guidance file
    (home-literal "/CLAUDE.md")
)


;; ===========================================================================
;; macOS Keychain
;;
;; Claude Code uses the macOS Keychain for storing authentication tokens.
;; Without Keychain access, Claude cannot authenticate with the Anthropic
;; API, making it unable to function.
;; ===========================================================================

(allow file-read* file-write*
    ;; User keychain database files for CLI login sessions
    (home-subpath "/Library/Keychains")
    ;; User security preferences read by some auth flows
    (home-literal "/Library/Preferences/com.apple.security.plist")
)

(allow file-read*
    ;; System-level security preferences
    (literal "/Library/Preferences/com.apple.security.plist")
    ;; System keychain for security CLI operations
    (literal "/Library/Keychains/System.keychain")
    ;; MDS message store, hosts se_SecurityMessages used by securityd IPC
    (subpath "/private/var/db/mds")
)

;; Directory traversal for keychain lookups and ~/Library/Caches subpaths
;; (Keychain, Xcode caches, Playwright, Node caches, etc.)
(allow file-read-metadata
    (home-literal "/Library")
    (home-literal "/Library/Keychains")
    (home-literal "/Library/Caches")
    (literal "/Library")
    (literal "/Library/Keychains")
)

;; Keychain operations depend on several security-related XPC services
(allow mach-lookup
    ;; Core keychain operations
    (global-name "com.apple.SecurityServer")
    ;; Login prompts/token unlock dialogs
    (global-name "com.apple.security.agent")
    ;; securityd backend for certificate/key queries
    (global-name "com.apple.securityd.xpc")
    ;; Auth host service for interactive credential flows
    (global-name "com.apple.security.authhost")
    ;; Secure enclave/credential mediation
    (global-name "com.apple.secd")
    ;; Additional trustd backend for keychain/security flows
    (global-name "com.apple.trustd")
)

;; Keychain database change notifications via shared memory
(allow ipc-posix-shm-read-data ipc-posix-shm-write-create ipc-posix-shm-write-data
    (ipc-posix-name "com.apple.AppleDatabaseChanged")
)


;; ===========================================================================
;; Dotfiles (read-only)
;;
;; Many home directory config files (~/.gitconfig, ~/.npmrc, ~/.zshrc, etc.)
;; are symlinks into the dotfiles repo. The sandbox resolves symlinks and
;; checks the target path, so read access to the dotfiles modules directory
;; is needed for those config files to be readable.
;; ===========================================================================

(allow file-read*
    (home-subpath "/Projects/dotfiles/modules")
)


;; ===========================================================================
;; Git configuration (read-only)
;;
;; Claude reads git config for commit authoring, ignore patterns, and
;; repository-level settings. Write access is not needed because git
;; config is not modified by the agent. Uses `prefix` to match variants
;; like .gitconfig.local, .gitignore_global, etc.
;; ===========================================================================

(allow file-read*
    ;; User gitconfig and variants (.gitconfig.local, etc.)
    (home-prefix "/.gitconfig")
    ;; User global gitignore variants (.gitignore, .gitignore_global, etc.)
    (home-prefix "/.gitignore")
    ;; XDG-style git config directory (config, ignore, attributes)
    (home-subpath "/.config/git")
    ;; Global gitattributes file
    (home-literal "/.gitattributes")
)


;; ===========================================================================
;; Docker
;;
;; Docker CLI plugins (including docker-compose) live under ~/.docker/cli-plugins/.
;; The docker daemon socket at /var/run/docker.sock is already reachable via
;; the /private/var/run metadata grant. Read-only access to ~/.docker is
;; sufficient for public registry pulls, building Dockerfiles, and compose.
;; Private registry auth tokens in ~/.docker/config.json are readable but
;; not writable (docker login would fail, which is fine for public-only use).
;; ===========================================================================

(allow file-read*
    (home-subpath "/.docker")
)

;; Buildx needs to write activity tracking and builder state
(allow file-write*
    (home-subpath "/.docker/buildx")
)

;; The docker binary is a symlink at /usr/local/bin/docker pointing into
;; /Applications/Docker.app. Without read access to the app bundle, the
;; symlink resolves but the target binary cannot be loaded.
(allow file-read*
    (subpath "/Applications/Docker.app")
)


;; ===========================================================================
;; SCM CLIs (gh, glab)
;;
;; Claude uses the GitHub CLI (gh) for PR creation, issue management, and
;; API calls. Full read/write access is needed because gh stores auth
;; tokens, caches API responses, and maintains state.
;; ===========================================================================

(allow file-read* file-write*
    ;; gh auth tokens and configuration
    (home-subpath "/.config/gh")
    ;; gh API response cache
    (home-subpath "/.cache/gh")
    ;; gh persistent state and extensions
    (home-subpath "/.local/share/gh")
    ;; gh runtime state files
    (home-subpath "/.local/state/gh")
)


;; ===========================================================================
;; SSH (scoped access)
;;
;; Git-over-SSH needs the SSH agent socket and non-sensitive config files.
;; Private keys are explicitly BLOCKED. The agent socket is needed for
;; key-based authentication without exposing the keys themselves.
;; ===========================================================================

;; Block all SSH key reads and writes by default. This is the most important
;; deny rule: even if a broader allow above inadvertently covers ~/.ssh,
;; this deny takes precedence for the full subtree.
(deny file-read* file-write*
    (home-subpath "/.ssh")
)

;; Allow directory traversal so the specific-file allows below can resolve
(allow file-read-metadata
    (home-literal "/.ssh")
)

;; Allow non-sensitive SSH metadata needed for git/remote operations
(allow file-read*
    ;; Host key verification cache (prevents MITM warnings)
    (home-literal "/.ssh/known_hosts")
    ;; SSH host aliases and IdentityFile selection used by git remotes
    (home-literal "/.ssh/config")
    ;; Include-based SSH config fragments
    (home-subpath "/.ssh/config.d")
    ;; SSH signature verification for git commit signing
    (home-literal "/.ssh/allowed_signers")
    ;; System SSH client configuration
    (literal "/private/etc/ssh/ssh_config")
    (subpath "/private/etc/ssh/ssh_config.d")
    ;; System-wide SSH crypto policy (ciphers, MACs, KEX algorithms)
    (literal "/private/etc/ssh/crypto.conf")
    (subpath "/private/etc/ssh/crypto")
)

;; Allow writing known_hosts so first-connect host key acceptance persists
(allow file-write*
    (home-literal "/.ssh/known_hosts")
    (home-literal "/.ssh/known_hosts.old")
)

;; SSH agent socket access. The agent holds decrypted private keys in memory
;; and performs signing operations on behalf of the client, so the client
;; never needs to read the key files directly.
(allow file-read-metadata
    ;; macOS 26+ ssh-agent socket directory
    (home-literal "/.ssh/agent")
)

;; Re-open the launchd listener sockets that were blocked in the temp
;; directory section. These are the paths where macOS places the SSH agent
;; socket via launchd.
(allow file-read* file-write*
    (regex #"^/private/tmp/com\.apple\.launchd\.[^/]+/Listeners$")
    (regex #"^/tmp/com\.apple\.launchd\.[^/]+/Listeners$")
    ;; macOS 26 ssh-agent socket directory (e.g. ~/.ssh/agent/s.*)
    (home-subpath "/.ssh/agent")
)

;; Allow outbound unix-socket connections to the SSH agent
(allow network-outbound
    (remote unix-socket (path-regex #"^/private/tmp/com\.apple\.launchd\.[^/]+/Listeners$"))
    (remote unix-socket (path-regex #"^/tmp/com\.apple\.launchd\.[^/]+/Listeners$"))
    (remote unix-socket (path-regex (string-append "^" HOME_DIR "/\\.ssh/agent(/.*)?$")))
)


;; ===========================================================================
;; Toolchain: Apple Command Line Tools (read-only)
;;
;; The CLT provides git, clang, make, ld, and other build essentials that
;; the /usr/bin shims delegate to. The literal entries at the top are
;; ancestor directory traversals needed so that reads into the subpath
;; entries below can resolve.
;; ===========================================================================

(allow file-read*
    ;; Ancestor directory traversal entries (required for path resolution
    ;; into the CLT tree)
    (literal "/Library")
    (literal "/Library/Developer")
    (literal "/Library/Developer/CommandLineTools")
    (literal "/Library/Developer/CommandLineTools/usr")
    (literal "/Library/Developer/CommandLineTools/usr/bin")
    (literal "/Library/Developer/CommandLineTools/usr/include")
    (literal "/Library/Developer/CommandLineTools/usr/lib")
    (literal "/Library/Developer/CommandLineTools/usr/libexec")
    (literal "/Library/Developer/CommandLineTools/usr/libexec/git-core")
    (literal "/Library/Developer/CommandLineTools/usr/share")
    (literal "/Library/Developer/CommandLineTools/SDKs")

    ;; Actual content: git plumbing commands, headers, libraries, man pages,
    ;; and SDK frameworks/headers
    (subpath "/Library/Developer/CommandLineTools/usr/libexec/git-core")
    (subpath "/Library/Developer/CommandLineTools/usr/include")
    (subpath "/Library/Developer/CommandLineTools/usr/lib")
    (subpath "/Library/Developer/CommandLineTools/usr/share")
    (subpath "/Library/Developer/CommandLineTools/SDKs")
)


;; ===========================================================================
;; Toolchain: Xcode
;;
;; For C++ development using Xcode's compiler, linker, and SDK. The
;; /usr/bin shims (make, clang, etc.) internally call xcrun which calls
;; xcodebuild to locate the real binaries inside Xcode.app.
;;
;; Key discovery chain: /usr/bin/make -> xcrun -> xcodebuild -find make
;; -> /Applications/Xcode.app/Contents/Developer/usr/bin/make
;;
;; xcodebuild needs cfprefsd mach services to read preferences (including
;; the Xcode license acceptance state), or it fails with exit code 69.
;; ===========================================================================

;; Read-only access to the Xcode app bundle. The entire bundle is granted
;; because CLI tools load SharedFrameworks and plugins from various
;; locations within Contents/.
(allow file-read*
    ;; /Applications directory listing for Xcode discovery
    (literal "/Applications")
    ;; Standard and beta Xcode app bundles
    (subpath "/Applications/Xcode.app")
    (subpath "/Applications/Xcode-beta.app")
    ;; Version-suffixed or renamed Xcode bundles (e.g. Xcode-15.4.app)
    (regex #"^/Applications/Xcode[^/]*\.app(/.*)?$")

    ;; On modern APFS macOS, /Applications is a firmlink and some path
    ;; resolution flows go through /System/Volumes/Data/Applications
    (literal "/System")
    (literal "/System/Volumes")
    (literal "/System/Volumes/Data")
    (literal "/System/Volumes/Data/Applications")
    (subpath "/System/Volumes/Data/Applications/Xcode.app")
    (subpath "/System/Volumes/Data/Applications/Xcode-beta.app")
    (regex #"^/System/Volumes/Data/Applications/Xcode[^/]*\.app(/.*)?$")

    ;; CoreDevice and CoreSimulator private frameworks installed globally
    (literal "/Library/Developer/PrivateFrameworks")
    (subpath "/Library/Developer/PrivateFrameworks")
    (literal "/Library/Developer/CoreSimulator")
    (subpath "/Library/Developer/CoreSimulator")

    ;; Xcode preferences (user-level)
    (home-literal "/Library/Preferences/com.apple.dt.Xcode.plist")
    ;; Xcode license acceptance state (system-level). Without this,
    ;; xcodebuild refuses to run ("You have not agreed to the Xcode
    ;; license agreements").
    (literal "/Library/Preferences/com.apple.dt.Xcode.plist")
)

;; Per-user Xcode build artifacts, archives, device-support, and simulator
;; state. These need read/write because builds produce output here.
(allow file-read* file-write*
    (home-subpath "/Library/Developer/Xcode")
    (home-subpath "/Library/Developer/CoreSimulator")
    (home-subpath "/Library/Developer/XCTestDevices")
    (home-subpath "/Library/Developer/CoreDevice")
    (home-subpath "/Library/Caches/com.apple.dt.Xcode")
)

;; Allow initial directory creation and direct plist updates for Xcode
;; user state directories
(allow file-write*
    (home-literal "/Library")
    (home-literal "/Library/Developer")
    (home-literal "/Library/Developer/Xcode")
    (home-literal "/Library/Developer/CoreSimulator")
    (home-literal "/Library/Developer/XCTestDevices")
    (home-literal "/Library/Developer/CoreDevice")
    (home-literal "/Library/Caches")
    (home-literal "/Library/Caches/com.apple.dt.Xcode")
    (home-literal "/Library/Preferences/com.apple.dt.Xcode.plist")
)

;; Xcode persists some preferences through cfprefsd
(allow user-preference-read user-preference-write
    (preference-domain "com.apple.dt.Xcode")
    ;; Generic preference domain used by CFPreferences API calls. Needed by
    ;; xcodebuild for reading system-wide defaults.
    (preference-domain "kCFPreferencesAnyApplication")
)

;; Simulator/device tooling XPC services
(allow mach-lookup
    (global-name "com.apple.CoreSimulator.CoreSimulatorService")
    ;; CoreDevice transport used by physical-device tooling
    (global-name "com.apple.remoted.coredevice")
    ;; Remote pairing service used by devicectl/device flows
    (global-name "com.apple.CoreDevice.remotepairingd")
    ;; CoreDevice manager variants for paired-device operations
    (global-name-regex #"^com\.apple\.coredevice\.devicemanager(\.|$)")
)


;; ===========================================================================
;; Toolchain: Homebrew (read-only)
;;
;; Homebrew on Apple Silicon installs to /opt/homebrew. This is already
;; covered by the broad (subpath "/opt") in the System Runtime section,
;; but this explicit grant makes the intent clear and survives if the
;; /opt grant is ever narrowed.
;; ===========================================================================

(allow file-read*
    (subpath "/opt/homebrew")
)


;; ===========================================================================
;; Toolchain: Go
;;
;; Go needs its module cache (~/go), build cache (~/Library/Caches/go-build),
;; and env config (~/Library/Application Support/go/env). Without write access
;; to the build cache, `go build` fails immediately.
;; ===========================================================================

(allow file-read* file-write*
    ;; GOPATH: module downloads, compiled packages, and installed binaries
    (home-subpath "/go")
    ;; Build cache used by the Go compiler
    (home-subpath "/Library/Caches/go-build")
    ;; Go environment config
    (home-subpath "/Library/Application Support/go")
)


;; ===========================================================================
;; Toolchain: Node.js
;;
;; Claude Code itself is a Node.js application, so the Node runtime, npm,
;; and related package manager caches need read/write access. This also
;; covers version managers (nvm, fnm) and native module build caches
;; (node-gyp).
;; ===========================================================================

(allow file-read* file-write*
    ;; Node version managers
    (home-subpath "/.nvm")
    (home-subpath "/.fnm")

    ;; npm
    (home-subpath "/.npm")
    (home-subpath "/.config/npm")
    (home-subpath "/.cache/npm")
    (home-subpath "/.cache/node")
    (home-literal "/.npmrc")

    ;; configstore (npm ecosystem config persistence)
    (home-subpath "/.config/configstore")

    ;; node-gyp (native module compilation cache)
    (home-subpath "/.node-gyp")
    (home-subpath "/.cache/node-gyp")

    ;; yarn (classic + modern)
    (home-subpath "/.yarn")
    (home-literal "/.yarnrc")
    (home-literal "/.yarnrc.yml")
    (home-subpath "/.config/yarn")
    (home-subpath "/.cache/yarn")
    (home-subpath "/Library/Caches/Yarn")

    ;; corepack
    (home-subpath "/.cache/node/corepack")
    (home-subpath "/Library/Caches/node/corepack")

    ;; Browser automation / test runners
    (home-subpath "/Library/Caches/ms-playwright")

    ;; Claude CLI Node.js cache
    (home-subpath "/Library/Caches/claude-cli-nodejs")
)


;; ===========================================================================
;; Toolchain: Python (uv, pip, virtualenvs)
;;
;; uv is a fast Python package manager that caches downloads and built wheels
;; under ~/.cache/uv. Without write access to its cache, uv fails at startup
;; with "Failed to initialize cache".
;; ===========================================================================

(allow file-read* file-write*
    ;; uv package cache and state
    (home-subpath "/.cache/uv")
    (home-subpath "/.local/share/uv")

    ;; pip cache and config
    (home-subpath "/.cache/pip")
    (home-subpath "/.config/pip")
    (home-literal "/.pip/pip.conf")

    ;; pyenv version manager
    (home-subpath "/.pyenv")
)


;; ===========================================================================
;; Headless Chromium (Playwright, Puppeteer)
;;
;; Headless Chromium forks renderer/GPU subprocesses and communicates with
;; them via Mach ports. Without these grants, browser tests crash with
;; SIGSEGV and Playwright cannot kill its child processes (kill EPERM).
;;
;; Based on Agent Safehouse's chromium-headless.sb profile.
;; ===========================================================================

;; Chromium probes system state and accessibility preferences at startup
(allow file-read-metadata
    (literal "/private/var/db")
    (literal "/private/var/db/.AppleSetupDone")
    (home-literal "/Library")
    (home-literal "/Library/Application Support")
    (home-literal "/Library/Caches")
    (home-literal "/Library/Spelling")
)

(allow file-read*
    (literal "/private/etc")
    (home-literal "/Library/Preferences/com.apple.universalaccess.plist")
    (home-literal "/Library/Preferences/com.apple.Accessibility.plist")
    (home-literal "/Library/Preferences/com.apple.CoreGraphics.plist")
    (home-literal "/Library/Preferences/com.apple.symbolichotkeys.plist")
    (home-literal "/Library/Preferences/com.apple.ServicesMenu.Services.plist")
    (home-literal "/Library/Preferences/com.apple.speech.recognition.AppleSpeechRecognition.prefs.plist")
    (home-literal "/Library/Preferences/com.apple.SpeakSelection.plist")
    (home-literal "/Library/Preferences/com.apple.assistant.support.plist")
    (home-literal "/Library/Preferences/com.apple.assistant.backedup.plist")
    (home-literal "/Library/Preferences/pbs.plist")
    (home-literal "/Library/Preferences/com.apple.HIToolbox.plist")
    (literal "/Library/Preferences/com.apple.HIToolbox.plist")
    (home-subpath "/Library/Preferences/com.apple.LaunchServices")
    (home-subpath "/Library/Application Support/CrashReporter")
    (home-subpath "/Library/Spelling")
    (home-literal "/Library/Keyboard Layouts")
    (home-literal "/Library/Input Methods")
)

(allow user-preference-read
    (preference-domain "com.apple.hitoolbox")
)

;; Chromium uses Mach port rendezvous for IPC between the browser process
;; and its renderer/GPU children, and crashpad for crash reporting
(allow mach-register
    (global-name-regex #"^org\.chromium\.Chromium\.MachPortRendezvousServer\.")
    (global-name-regex #"^org\.chromium\.crashpad\.child_port_handshake\.")
    (local-name "com.apple.axserver")
    (local-name "com.apple.tsm.portname")
    (local-name "com.apple.coredrag")
)

;; System services used by Chromium for rendering, GPU compositing, font
;; loading, window management, accessibility, and crash reporting
(allow mach-lookup
    (global-name-regex #"^org\.chromium\.Chromium\.MachPortRendezvousServer\.")
    (global-name-regex #"^org\.chromium\.crashpad\.child_port_handshake\.")
    ;; GPU shader compilation
    (global-name "com.apple.MTLCompilerService")
    ;; Compositing and window server
    (global-name "com.apple.CARenderServer")
    (global-name "com.apple.windowserver.active")
    (global-name "com.apple.windowmanager.server")
    (global-name "com.apple.window_proxies")
    (global-name "com.apple.dock.server")
    ;; Transparency, consent, and control (TCC) for accessibility checks
    (global-name "com.apple.tccd")
    (global-name "com.apple.tccd.system")
    ;; Font loading
    (global-name "com.apple.fonts")
    (global-name "com.apple.FontObjectsServer")
    ;; Icon and type resolution
    (global-name "com.apple.iconservices")
    (global-name "com.apple.coreservices.appleevents")
    (global-name "com.apple.coreservices.sharedfilelistd.xpc")
    ;; HI services for accessibility integration
    (global-name "com.apple.hiservices-xpcservice")
    (global-name "com.apple.iohideventsystem")
    ;; Input method and text services
    (global-name "com.apple.tsm.uiserver")
    (global-name "com.apple.inputmethodkit.launchagent")
    (global-name "com.apple.inputmethodkit.launcher")
    (global-name "com.apple.inputmethodkit.getxpcendpoint")
    ;; Accessibility voice and input analytics
    (global-name "com.apple.accessibility.voices")
    (global-name "com.apple.inputanalyticsd")
    ;; AppKit runtime services
    (global-name "com.apple.ViewBridgeAuxiliary")
    (global-name "com.apple.appkit.restoration_storage")
    (global-name "com.apple.backgroundtaskmanagementagent")
    (global-name "com.apple.pbs.fetch_services")
    ;; Security policy checks
    (global-name "com.apple.security.syspolicy")
    (global-name "com.apple.security.syspolicy.exec")
    ;; Miscellaneous system services
    (global-name "com.apple.bsd.dirhelper")
    (global-name "com.apple.system.opendirectoryd.membership")
    (global-name "com.apple.logd.events")
    (global-name "com.apple.FileCoordination")
    (global-name "com.apple.powerlog.plxpclogger.xpc")
    (global-name "com.apple.naturallanguaged")
    (global-name-prefix "com.apple.distributed_notifications@")
)

;; Filesystem control needed by Chromium for APFS clone/snapshot operations
(allow system-fsctl
    (fsctl-command (_IO "h" 47))
)

;; IOKit device access for GPU compositing and input device handling
(allow iokit-open
    (iokit-user-client-class "RootDomainUserClient")
    (iokit-user-client-class "IOHIDParamUserClient")
    (iokit-user-client-class "AppleNVMeEANUC")
    (iokit-user-client-class "IOSurfaceRootUserClient")
    (iokit-user-client-class "AGXDeviceUserClient")
)

;; Chromium forks renderer subprocesses. Playwright needs to signal (kill)
;; those children for cleanup. Without broad signal, Playwright fails with
;; "kill EPERM" when tearing down browser processes.
(allow signal)


;; ===========================================================================
;; Security: explicit deny for sensitive directories (defense-in-depth)
;;
;; These denies override any broader allows above and block access to
;; credentials, personal files, and cloud provider configuration. Even if
;; a future edit accidentally broadens an allow rule, these denies will
;; still protect these paths.
;; ===========================================================================

(deny file-read* file-write*
    ;; Cloud provider credentials
    (home-subpath "/.aws")
    (home-subpath "/.gcloud")
    (home-subpath "/.azure")

    ;; Encryption keys and keyrings
    (home-subpath "/.gnupg")

    ;; Container/orchestration credentials
    (home-subpath "/.kube")

    ;; Password stores and auth files
    (home-subpath "/.password-store")
    (home-literal "/.authinfo")
    (home-literal "/.netrc")

    ;; Database credentials
    (home-literal "/.pgpass")
    (home-literal "/.my.cnf")

    ;; Legacy cloud credentials
    (home-literal "/.s3cfg")
    (home-literal "/.boto")

    ;; Personal directories that should never be touched by an AI agent
    (home-subpath "/Documents")
    (home-subpath "/Downloads")
    (home-subpath "/Pictures")
    (home-subpath "/Movies")
    (home-subpath "/Music")
)


;; ===========================================================================
;; Desktop (read/write)
;;
;; Used for cross-project plan documents and shared notes. Granted after
;; the deny-all block above so it is not caught by the personal directories
;; deny rule.
;; ===========================================================================

(allow file-read* file-write*
    (home-subpath "/Desktop")
)
