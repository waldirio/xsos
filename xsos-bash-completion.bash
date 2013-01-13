# This file is part of xsos, providing intelligent xsos tab-completion for BASH
# Save it to: /etc/bash_completion.d/
#
# Revision date:  2013/01/13, matching up with xsos v0.1.2
# Latest version: <http://github.com/ryran/xsos>
# 
# Copyright 2013 Ryan Sawhill <rsaw@redhat.com>
# 
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#    General Public License <gnu.org/licenses/gpl.html> for more details.
#
#-------------------------------------------------------------------------------

_xsos()  {
  
  # Variables
  local curr prev shrtopts longopts
  
  # Wipe out COMPREPLY array
  COMPREPLY=()
  
  # Set cur & prev appropriately
  curr=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}
  
  # Short and long options
  shrtopts="-h -V -U
            -a -b -o -c -m -d -l -e -i -n -s -p
            -u -v -w
            -x -y -z"
            
  longopts="--help --version --update
            --all --bios --os --cpu --mem --disks --lspci --ethtool --ip --net --sysctl --ps
            --B --C --M --D --L --I --N --P
            --unit --verbose --width
            --nocolor --less --more"
  
  # Check previous arg to see if we need to do anything special
  case "$prev" in
  
      # Disable autocompletion for solo options that can only be run alone
      -h|--help|-V|--version|-U|--update)
          return 0
          ;;
          
      # These special opts require filenames as arguments
	    --B|--C|--M|--D|--L|--I|--N|--P)
	        compopt -o plusdirs  # Important!
	        COMPREPLY=( $(compgen -f -- "$curr") )
          return 0
          ;;
          
      # For unit, choices are b-t
      -u|--unit)
          COMPREPLY=( $(compgen -W "b k m g t" -- "$curr") )
          return 0
          ;;
          
      # For verbosity, choices are 0-4
      -v|--verbose)
          COMPREPLY=( $(compgen -W "0 1 2 3 4" -- "$curr") )
          return 0
          ;;
          
      # For width, choices are w, 0, or any number
      -w|--width)
          COMPREPLY=( $(compgen -W "w 0" -- "$curr") )
          return 0
  
  esac
  
  # Now that we've made it past the options that require args,
  # we can enable directory completion
  compopt -o plusdirs
   
  if [[ $curr == --* ]]; then
      # If current arg starts w/2 dashes, attempt to autocomplete long opts
      COMPREPLY=( $(compgen -W "$longopts" -- "$curr") )
      return 0
  elif [[ $curr == -* ]]; then
      # Otherwise, if current only starts w/1 dash, attempt autocomplete short opts
      COMPREPLY=( $(compgen -W "$shrtopts" -- "$curr") )
      return 0
  fi
}

# Add the names of any xsos aliases (or alternate file-names) to the end of the following line
complete -F _xsos xsos

