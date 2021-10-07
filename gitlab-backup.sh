#!/bin/bash
# 
# Dwiyan 
# Script For Backup Gitlab and send file to another host with md5sum
#
# https://panthalassa.eth

GITLAB_RAKE=`which gitlab-rake`
HOST_BACKUP="host-backup.ohmeth.com"
PATH_HOST_BACKUP="/backup"
DIR_RESULT_BACKUP="/var/opt/gitlab/backup/"

if [ -f $GITLAB_RAKE ]
then	
     gitlab-rake gitlab:backup:create
     dir_backup=`cat /etc/gitlab/gitlab.rb | grep "gitlab_rails\['backup_path'\]" | sed "s/^ //" | awk -F"=" '{print $2}' | sed "s/^ //"| sed "s/^\"//"| sed "s/\"//"`
     file_name=`ls -1tr $dir_backup | grep gitlab_backup.tar | egrep -v "grep|md5sum" | tail -n1`
     cd $DIR_RESULT_BACKUP
     md5sum $file_name | awk '{print $1}' > $file_name.md5sum
     chown git:git $file_name.md5sum
     rsync -avz --progress --delete -e ssh $file_name root@$HOST_BACKUP:$PATH_HOST_BACKUP
     rsync -avz --progress --delete -e ssh $file_name.md5sum root@$HOST_BACKUP:$PATH_HOST_BACKUP
     rm $file_name.md5sum
else
     echo "gitlab-rake not found"
fi
