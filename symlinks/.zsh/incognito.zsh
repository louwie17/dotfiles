# allows 'incognito' mode where commands aren't logged to the history
# to start, run 'incognito' function.  (prompt bars will change to cyan)
# to stop, run 'normal' function.  (prompt bars will return to white)

accept-line() {
  if [ "$INCOGNITO" = "TRUE" ]
  then
    BUFFER=" $BUFFER"
  fi
  zle .accept-line
}
zle -N accept-line

precmd(){
  capture=`echo $INCOGNITO` # this is stupid, won't work without it!
  if [ "$capture" = "TRUE" ]
  then
    bar_color="$fg[cyan]"
  else
    bar_color=""
  fi
  PROMPT="$bar_color╭─${user_host} ${current_dir} ${rvm_ruby} ${git_branch}
$bar_color╰─%B$%b "
}

function toggle-incognito() {
  if [ "$INCOGNITO" = "TRUE" ]
  then
    export INCOGNITO="FALSE"
  else
    export INCOGNITO="TRUE"
  fi
}

zle -N toggle-incognito
bindkey '\Cp' toggle-incognito
