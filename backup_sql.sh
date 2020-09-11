daily_backup(){
	export PATH=/bin:/usr/bin:/usr/local/bin
	TODAY=`date +"%d%b%Y"`


	DB_BACKUP_PATH='/home/hadoop-thiyagu/coda/backups'
	DB_NAME='student_details'
	MYSQL_HOST='localhost'
	MYSQL_PORT='3306'
	MYSQL_USER='root'
	MYSQL_PASSWORD='password'

	sudo mkdir -p ${DB_BACKUP_PATH}/${TODAY}

	mysqldump -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${DB_NAME} |
	 gzip > ${DB_BACKUP_PATH}/${TODAY}/${DB_NAME}-${TODAY}.sql.gz

		 
	 
	 if [ $? -eq 0 ]; then
     	 echo "Database backup successfully completed"
     else
	     echo "Error found during backup"
	     exit 1
     fi
}

daily_backup