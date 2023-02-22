[core]
	mergeoptions = --no-edit
	editor = vim
	autocrlf = false
	whitespace = trailing-space,space-before-tab,indent-with-non-tab,cr-at-eol
	filemode = false
	longpaths = true
[user]
	name = Juan Cruz Viotti
	email = jv@jviotti.com
	signingkey = 9FB15665AD73D9B7
[sendemail]
	smtpserver = /usr/local/bin/msmtp
	smtpserveroption=--account
	smtpserveroption=mailfence
	annotate = yes
[color]
	ui = true
[pull]
	rebase = false
[push]
	default = current
	followtags = true
[alias]
	ush = push
	ull = pull
	merge = merge --no-ff
	contributors = shortlog --summary --numbered --all --no-merges
	undo-commit = reset --soft HEAD^
	delete-remote-branch = "!f() { git push origin :$1; }; f"
	delete-merged-branches = "!f() { git checkout --quiet master && git branch --merged | grep --invert-match '\\\\*' | xargs -n 1 git branch --delete; git checkout --quiet @{-1};  }; f"
	unstage = reset HEAD --
	last = log -1 HEAD
	amend = commit --amend
	checkout-remote = "!f() { git branch -D $1 && git fetch && git checkout $1; }; f"
	sync = "!f() { git fetch $1 && git checkout master && git merge $1/master; }; f"
	push-track = push -u origin
	track-master = "!f() { git fetch && git branch --set-upstream-to=origin/master master; }; f"
	glog = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
	publish = "!f() { git push-track && hub pull-request; }; f"
	amend-with-files = commit --amend -C HEAD
	conflicts = diff --name-only --diff-filter=U
	delete-remote-tag = "!f() { git push origin :refs/tags/$1; }; f"
	clean-branches = "!f() { git branch | grep -v "master" | xargs git branch -D; }; f"
	authors = "!f() { git log --all --format='%aN <%cE>' | sort -u; }; f"
%%ifeq OS macos
[credential]
	helper = osxkeychain
%%else
[credential]
	helper = cache --timeout=3600
%%endif
[filter "media"]
	clean = git-media-clean -- %f
	smudge = git-media-smudge -- %f
	process = git-lfs filter-process
[commit]
	template = ~/.gitdefaultcommit
	gpgsign = true
[merge]
	tool = vimdiff
	conflictstyle = diff3
[diff "hex"]
	textconv = hexdump
	binary = true
[mergetool]
	prompt = false
[status]
	showuntrackedfiles = all
[filter "lfs"]
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	required = true
	process = git-lfs filter-process
[github]
	user = jviotti
[pass]
	signcommits = true
%%ifeq OS macos
[gpg]
	program = gpg
%%endif
[http]
	cookiefile = ~/.gitcookies
[gerrit]
	host = true
[init]
	defaultBranch = master
