#!/bin/ksh
#--------------------------------------------------------------------------------------
# Author(s): Sree Guruparan P A 
# Date     : Feb-28, 2011
#
# This script finds and removes files with a number of days old (When passed).
# 
# The config file contains the following: 
# ^^^^^^
# 1.  Path to directory.
# 2.  Age of the file. 
# 3.  File name pattern.
#
# Like this:
# $HOME 90 *.temp
# $HOME/code/c 90 *.out
# /tmp 90 *.c
# 
# These values are stored in $HOME/config filename file_remove.cfg
#
# Return codes:
# ^^^^^^^^^^^^^
# 0 = OK
# Any other = Cleanup Failed
#
# Parameters should be:
# SCRIPT <path to directory> <Number of Days> <File Name Pattern>
#
# Version      Date           Name                   Description
#--------------------------------------------------------------------------------------
# 1.0          Feb-28, 20011   Sree Guruparan P A        Initial Version.
#--------------------------------------------------------------------------------------
log='/tmp/file_remove.log'
HDR=".................................................................................."

delete_files(){
 #-- Set up the initial parameters.
 if [[ $# -eq 3 ]]; then
    dirPath=$1
    noDaysOld=$2
    fileNamePattern=$3

  #-- Log the parameters passed in for the script.
  echo " Looking for the files in directory : " $dirPath           | tee -a $log
  echo " Number of days old                 : " $noDaysOld         | tee -a $log
  echo " Looking for Filename of Pattern    : " $fileNamePattern   | tee -a $log

  #-- Expand any environment varriable set. Like $HOME/$LOG_HOME/$RUN_HOME.. etc.
  eval $(echo cd $dirPath)

  #-- Check for the directory existance.
  if [[ $? = 0 ]]; then    
    #-- Removing the files. We will prune the search to current path only and don't look into sub-directories.
    find . \( ! -name . -prune \)  -type f \( -mtime $noDaysOld -o -mtime +$noDaysOld \) -name "$fileNamePattern" -exec rm -f {} \;

    #-- Check whether the remove completed / failed.
    if [[ $? = 0 ]]; then
      echo " All file(s) removed. " 
    else
      echo " Error occured while removing files. " 
    fi  
    echo " "
  else
    echo " Error: Incorrect or wrong directory."
  fi
 fi
}

# Set up the local parameters.
echo "File execution started at $(date)" > $log
echo $HDR | tee -a $log

# Log the startup of the script in log.
echo " Script execution started at        : " $(date) | tee -a $log
 
echo " Reading the list of files to be removed from $HOME/config/file_remove.cfg" | tee -a $log
while read dir age pattern
do
  delete_files $dir $age $pattern 
done < $HOME/config/file_remove.cfg

echo " Script execution finished at       : " $(date)  | tee -a $log
echo $HDR | tee -a $log
exit 0
### END OF SCRIPT ###