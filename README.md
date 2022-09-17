# DONATE

1. Ethereum : <pre>0xB0e6e6c379389bBB30fACD427e02d74d27ec0C78</pre>
2. Near Blockchain : <pre>xoreth.near</pre>
3. Mina Protocol : <pre>B62qiiBBXKN5CdgXv7wPkXxC1prdzQxwfaTMAi3isAeb9F7gCbzi5dU</pre>



## GITLAB BACKUP / RESTORE

### WORKFLOW
**Gitlab-A** --> doing backup and send data backup and md5sum file backup to Gitlab-B

**Gitlab-B** --> Checking rsync process, if still running process restore stop until rsync finished. After rysnc finished, script will be check data backup and md5sum, if exsist restore backup file in Gitlab-B, or if not exsist Gitlab-B will be cancel the process.

### Noted
Gitlab must be same version. if not same will be failed to restore.


### Installation
Install that gitlab-backup.wjt script in existing server for backup using crontab 
(10 3 * * * /bin/bash /opt/crontab/gitlab-backup.sh)
Install that gitlab-restore.wjt script in new server for restore using crontab 
(10 */3 * * * /bin/bash /opt/crontab/gitlab-restore.sh)



