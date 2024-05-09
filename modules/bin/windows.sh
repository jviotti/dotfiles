#!/bin/sh

set -o errexit
set -o nounset

# Start a developer prompt from within WSL

VS_YEAR="2022"
VS_EDITION="Community"
VS_PATH="C:\\Program Files\\Microsoft Visual Studio\\$VS_YEAR\\$VS_EDITION"
VS_DEV_SHELL_DLL="$VS_PATH\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
VS_ARCH="x64"
VS_DEV_ARGUMENTS="-arch=$VS_ARCH -host_arch=$VS_ARCH"
# Not sure how to automatically determine this. 
# Get it from how Windows Terminal runs the Developer prompts
VS_INSTALL_PATH="be59fc7d"
PS_COMMAND="Import-Module \"$VS_DEV_SHELL_DLL\""
PS_COMMAND="$PS_COMMAND; Enter-VsDevShell $VS_INSTALL_PATH -DevCmdArguments \"$VS_DEV_ARGUMENTS\""
PS_COMMAND="$PS_COMMAND; cd \$HOME"

exec powershell.exe -NoExit -Command "&{$PS_COMMAND}"
