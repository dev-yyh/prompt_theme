#!/bin/sh

function make_left_prompt() {
  RETVAL=$1

  for idx in ${!left_prompt_elements[*]}
  do
# get a string of an element    
    f_color="${left_prompt_segment_foreground_colors[idx]}"
    element="$(${left_prompt_elements[idx]} $f_color $RETVAL)"
    let length+=$?

# add color to an element
    e_color="\e[0m"
#    f_color="\e[38;5;${left_prompt_segment_foreground_colors[idx]}m"
    b_color="\e[48;5;${left_prompt_segment_background_colors[idx]}m"
    str+="${b_color}$element${e_color}"

# add end_symbol to a string
    let last_idx=${#left_prompt_elements[*]}-1
    if [ $idx -eq $last_idx ]; then # last element
      f_color="\e[38;5;${left_prompt_segment_background_colors[idx]}m"
      str+="${f_color}${LEFT_PROMPT_SEGMENT_END_SYMBOL}${e_color}"
      let length+=1
    else
      f_color="\e[38;5;${left_prompt_segment_background_colors[idx]}m"
      b_color="\e[48;5;${left_prompt_segment_background_colors[idx+1]}m"
      str+="${f_color}${b_color}${LEFT_PROMPT_SEGMENT_END_SYMBOL}${e_color}"
      let length+=1
    fi
  done

  echo -e "$str"
  
  return $length
}

function make_right_prompt() {
  RETVAL=$1

  for idx in ${!right_prompt_elements[*]}
  do
# get a string of an element
    f_color="${right_prompt_segment_foreground_colors[idx]}"
    element="$(${right_prompt_elements[idx]} ${f_color} $RETVAL)"
    let length+=$?

# add start_symbol to a string
    if [ $idx -eq 0 ]; then # first element
      f_color="\e[38;5;${right_prompt_segment_background_colors[idx]}m"
      str+="${f_color}${RIGHT_PROMPT_SEGMENT_START_SYMBOL}${e_color}"
      let length+=1
    else
      f_color="\e[38;5;${right_prompt_segment_background_colors[idx]}m"
      b_color="\e[48;5;${right_prompt_segment_background_colors[idx-1]}m"
      str+="${f_color}${b_color}${RIGHT_PROMPT_SEGMENT_START_SYMBOL}${e_color}"
      let length+=1
    fi

# add color to an element
    e_color="\e[0m"
 #   f_color="\e[38;5;${right_prompt_segment_foreground_colors[idx]}m"
    b_color="\e[48;5;${right_prompt_segment_background_colors[idx]}m"
    str+="${b_color}$element${e_color}"
  done

  echo -e "$str"
  
  return $length
}

function make_mid_prompt() {
  
# get a mid_prompt_symbol
  mid_length=$1
  for (( i = 0; i < $mid_length; i++ ))
  do
    element+="${MID_PROMPT_SEGMENT_SYMBOL}"
  done

# add color to an element
  e_color="\e[0m"
  f_color="\e[38;5;${mid_prompt_segment_color}m"
  str+="${f_color}$element${e_color}"

  echo -e "$str"
}

function make_line1_prompt() {
  l_str="$(make_left_prompt $1)"
  l_length=$?
  r_str="$(make_right_prompt $1)"
  r_length=$?
 
  width=$(tput cols)
  let "mid_length=$width - $l_length - $r_length"
  
  if [ $mid_length -lt 0 ]; then
    l_str=$(f_pwd)
    str="${l_str}"
  else
    mid_str="$(make_mid_prompt $mid_length)"
    str="${l_str}${mid_str}${r_str}"
  fi

  echo -e "$str"
}

function make_line2_prompt() {
# get a prompt_symbol  
  element="${PROMPT_SYMBOL}"

# add color to an element
  e_color="\e[0m"
  f_color="\e[38;5;${prompt_color}m"
  str="${f_color}$element${e_color}"

  echo -e "$str "
}

function build_prompt() {
  RETVAL=$?
  line1="$(make_line1_prompt $RETVAL)"  
  line2="$(make_line2_prompt $RETVAL)"

  echo -e "${line1}"
  echo -e "${line2}"
}
