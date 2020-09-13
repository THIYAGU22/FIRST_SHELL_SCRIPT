#!/bin/bash

source credentials.sh

installer()
{
  echo "is this  installer working?"
  #OS=$(lsb_release -a)
  #VER=$(uname -r)
  #echo "${OS}";
  #echo $VER;
  #echo $os;
  if [[ $os == 'ubuntu' ]]; then 
  	echo 'STARTING UBUNTU INSTALLATION';
  	sudo apt-get -y install apache2
  	sudo apt-get -y install mysql-server
  	sudo apt-get -y install php libapache2-mod-php php-mysql 
  elif [[ $os == 'rhel' ]]; then 
  	echo 'STARTING RHEL INSTALLATION';
  	sudo yum -y install httpd
  	sudo yum -y install mod_ssl openssl
  	sudo yum -y php php-mysql php-gd php-mbstring
  	sudo yum -y install mysql-server

  else
  	echo 'unknown os detected use lsb_release -a on your terminal';
  fi
} 
starter()
{
 echo "is this  starter working?"

 if [[ $os == 'ubuntu' ]]; then 
 	echo 'STARTING UBUNTU LAMP SERVICES'
 	sudo systemctl start apache2
 	sudo /etc/init.d/mysql start
 elif [[ $os == 'rhel' ]]; then 
  	echo 'STARTING RHEL SERVICES';
  	sudo systemctl enable httpd.service
    sudo service mysql start
  else
  	echo 'unknown os detected use lsb_release -a on your terminal';
  fi
}
stop_services()
{

echo "is this stopper working?"

 if [[ $os == 'ubuntu' ]]; then 
 	echo 'STARTING UBUNTU LAMP SERVICES'
 	sudo systemctl stop apache2
 	sudo /etc/init.d/mysql stop
 elif [[ $os == 'rhel' ]]; then 
  	echo 'STARTING RHEL SERVICES';
  	sudo systemctl stop httpd.service
    sudo service mysql stop
  else
  	echo 'unknown os detected use lsb_release -a on your terminal';
  fi

}

git_clone(){
	#cd /home/hadoop-thiyagu/Desktop
	#ls -dl;
	cd /var/www/html
	sudo chmod 777 /var/www/html
	sudo rm -rf php-mysqli-connection
	sudo git clone https://github.com/THIYAGU22/php-mysqli-connection.git
	cd /var/www/html/php-mysqli-connection
	cp * ../
	cd ..
	mysql -h "localhost" -u "$MYSQL_ROOT" -p"$MYSQL_PASS" < "db_table_manipulation.sql"
}


args=("$@")

router="${args[0]}";

os='X' 
if [[ `which yum` ]]; then
   os='rhel';
elif [[ `which apt` ]]; then
   os='ubuntu';
elif [[ `which apk` ]]; then
   os='alpine';
else
   os='unknown';
fi

#Pass the variable in string 
case "$router" in 
    #case 1 
    "1") installer;;
      
    #case 2 
    "2") if installer;
		then 
		 starter;
		fi
	;;
    #case 3 
    "3") stop_services;; 

	#case 4
    "4") sudo sh ./backup_sql.sh;;

     #case 5
    "5") echo -e "INVALID OPTIONS"
esac 

git_clone
