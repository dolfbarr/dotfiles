# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/bashrc.pre.bash"
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/dolf/.sdkman"
[[ -s "/home/dolf/.sdkman/bin/sdkman-init.sh" ]] && source "/home/dolf/.sdkman/bin/sdkman-init.sh"

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/bashrc.post.bash"
