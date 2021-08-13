#!/bin/sh

function _f_git_branch() {
# get a string
  str="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/ ')"
  length=${#str}

# add foreground color to an element
  color=$1
  f_color="\e[38;5;${color}m"

  if [ -z "$str" ]; then
    echo -e ""
  else    
    echo -e " ${f_color}${GIT_ICON} ${BRANCH_ICON}$str "
    let length+=5
  fi

  return $length
}

function _f_time() {
# get a string
  str=" `date "+%H:%M:%S"` "
  length=${#str}

# add foreground color to an element
  color=$1
  f_color="\e[38;5;${color}m"
 
  echo -e "${f_color}$str${TIME_ICON} "
  let length+=2

  return $length
}

function _f_pwd() {
# get a string
  str=" $(pwd | sed "s/$(echo $HOME| sed 's/\//\\\//g')/\~/") " # $HOME -> ~
  length=${#str}

# add foreground color to an element
  color=$1
  f_color="\e[38;5;${color}m"
 
  echo -e " ${f_color}${FOLDER_ICON}$str"
  let length+=2
  return $length  
}

function _f_context() {
# get a string
  str=" $USER@$HOSTNAME "
  length=${#str}
 
# add foreground color to an element
  color=$1
  f_color="\e[38;5;${color}m"
  
  echo -e " ${f_color}${LINUX_ICON}$str"
  let length+=2
  
  return $length
}

function _f_status() {
  color=$1
  RETVAL=$2
  
  if [ "$RETVAL" = "0" ]; then # Success
    ok_color="$(echo ${color}|sed 's/\([0-9][0-9][0-9]\)\(.*\)/\1/')" 
    f_color="\e[38;5;${ok_color}m"  
    
    echo -e " ${f_color}${OK_ICON} "
    let length+=3
  else # Fail
    fail_color="$(echo ${color}|sed 's/\([0-9][0-9][0-9]\)\(.*\)/\2/')" 
    f_color="\e[38;5;${fail_color}m"  
    
    echo -e " ${f_color}${FAIL_ICON} "
    let length+=3
  fi

  return $length
}
