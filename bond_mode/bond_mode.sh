#! /bin/sh
#
# Copyright (C) 2003, 2005-2007, 2011 Free Software Foundation, Inc.

# writer stone.zhang
# This script is a wrapper for ansible-playbook
      func_usage ()
      {
        echo "GNU bond_mode.shell script function library version $version"
        echo "Usage: ./bond_mode.sh [OPTION] your_hostlist_file
[OPTION]:
         -h        :print help messages
         -v        :print shell version 
         -check    :check host bonding status,if mode!=1 they will be record in /tmp/need_fix.txt!
         -change    :change host bonding mode to 1 from your_hostlist_file that you give!"
      }
if test $# -le 2; then
  case "$0" in
    bond_mode.sh | */bond_mode.sh | *\\bond_mode.sh)
      progname=$0
      version=1.0
      hostfile=$2
      # func_usage
      # outputs to stdout the --help usage message.
      # func_version
      # outputs to stdout the --version message.
      func_version ()
      {
        echo "$progname  $version"
        echo "Copyright (C) 2003-2007 Free Software Foundation, Inc.
License GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law."
        echo "Written by" "stone zhang"
      }
      func_check ()
      {
       if test -f /tmp/need_fix.txt;then
        echo "backup /tmp/need_fix.txt to /tmp/need_fix.txtback`date '+%Y%m%d%H%M'`"
       mv /tmp/need_fix.txt /tmp/need_fix.txtback`date '+%Y%m%d%H%M'` 
       fi
        echo "ansible-playbook change_bondmode.yml -i "$hostfile" --tags pre_job,check_status"
        ansible-playbook ./change_bondmode.yml -i $hostfile --tags pre_job,check_status
      }
      func_change ()
      {
        echo "ansible-playbook change_bondmode.yml -i "$hostfile" --tags change_mode"
        ansible-playbook ./change_bondmode.yml -i $hostfile --tags change_mode
      }

      if test $# = 1; then
        case "$1" in
          --help | --hel | --he | -h )
            func_usage; exit 0 ;;
          --version | --versio | --versi | --vers | --ver | --ve | -v )
            func_version; exit 0 ;;
        esac
      else
         if test $# = 2; then
           case "$1" in
             -check )
               func_check; exit 0 ;;
             -change )
               func_change; exit 0 ;;
           esac
         else
           func_usage
           exit 0 
         fi 
      fi
      func_usage 1>&2
      exit 1
      ;;
  esac
else
 func_usage
exit 0 
fi
