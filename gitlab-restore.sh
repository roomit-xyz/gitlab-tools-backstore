#!/bin/bash
#
# Dwiyan 
# Script Restore Data Gitlab
# Default Backup FHS in /backup
#
# https://panthalassa.eth

user_backup="root"
host_backup="main.ohmeth.com"
check_rsync_backup=`ssh $user_backup@$host_backup "ps -ef | grep rsync| grep -v grep|wc -l"`
dir_restore="/backup";


if [ $check_rsync_backup -gt 0 ]
then
  echo "`date` Rsync process still running";
  exit 0;
else
 cd $dir_restore
 check_file=`ls -1tr|grep gitlab_backup.tar| egrep -v "grep|md5sum|original_remote_data"`
 check_file_value=`ls -1tr|grep gitlab_backup.tar| egrep -v "grep|md5sum|original_remote_data"|wc -l`
 if [ $check_file_value -gt 0 ]
 then
   if [ -f $check_file ]
   then
      echo "`date` file data gitlab found";
      check_sum=`ls -1tr | grep  "md5sum" | egrep -v "grep|original_remote_data"`
      if [ ! -f $check_sum ]
      then
         echo "`date` md5sum file not found";
         exit 0
      else
         echo "`date` file md5sum found";
         data_sum_remote=`cat $check_sum`;
         data_sum_local=`md5sum $check_file | awk '{print $1}'`
         if [ "$data_sum_remote" == "$data_sum_local" ]
         then
            echo "`date` data summing is match"
            mkdir -p original_remote_data
            backup_gitlab=`echo "$check_file" | sed "s/_gitlab_backup.tar//"`
            chown git:root $dir_restore
            chown git:git -R $dir_restore/*
            gitlab-ctl stop unicorn
            gitlab-ctl stop sidekiq
            gitlab-ctl status | grep down
            gitlab-rake gitlab:backup:restore BACKUP=$backup_gitlab force=yes
            gitlab-ctl restart
            gitlab-rake gitlab:check SANITIZE=true
            rm -rf $dir_restore/original_remote_data/*
            mv $check_file original_remote_data
            for i in `ls -1 | grep -v "original_remote_data"`
            do
               echo "`date` remove data  $i"
               rm -rf $i
            done
         else
            echo  "`date` data summing is not match"
            exit 0
         fi
      fi
   fi
   else
      echo "`date` md5sum file Tersedia";
      exit 0
 fi  
fi

