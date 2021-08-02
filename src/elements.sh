#!/bin/sh

function f_git_branch() {
  str="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/ ')"
  length=${#str}
  if [ -z "$str" ]; then
    echo -e ""
  else    
    echo -e " ${GIT_ICON} ${BRANCH_ICON}$str "
    let length+=5
  fi

  return $length
}

function f_time() {
  str=" `date "+%H:%M:%S"` "
  length=${#str}
  echo -e "$str${TIME_ICON} "
  let length+=2

  return $length
}

function f_pwd() {
  str=" $(pwd | sed "s/$(echo $HOME| sed 's/\//\\\//g')/\~/") " # $HOME -> ~
  length=${#str}
  echo -e " ${FOLDER_ICON}$str"
  let length+=2
  return $length  
}

function f_context() {
  str=" $USER@$HOSTNAME "
  length=${#str}
  
  echo -e " ${LINUX_ICON}$str"
  let length+=2
  
  return $length
}
