#!/bin/bash
#ip=$(python3 -c 'import data;data.ip()')
#username=$(python3 -c "import data;data.username()")
#password=$(python3 -c "import data;data.password()")
#echo $ip
#p="sshpass -p $password ssh -o StrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $username@$ip 2>/dev/null "
#cmd="echo $password | sudo -S useradd -m -p "
#eval '$p $cmd 2>>err_logs.txt'
while getopts 'ahvsr:' OPTION; do
  case "$OPTION" in
    a)
	echo "Creating new user"
	read -p "Enter Username: " user
	read -s -p "Enter password: " pass_
	echo " "
#	param=10
#	echo $user
	check=$(python3 data.py 'a' $user $pass_)
	if [ "$check" -eq 1 ];
	then
#		echo yes
		ip=$(python3 data.py 'ip')
		username=$(python3 data.py 'username')
#		echo "USERNAME $ip"
		password=$(python3 data.py 'password')
		p="sshpass -p $password ssh -o StrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $username@$ip 2>/dev/null "
		cmd="echo $password | sudo -S useradd -m -p $pass_ $user"
		eval '$p $cmd 2>>err_logs.txt'
		echo Successfully created!
	else
		echo Username already exists
	fi
      ;;
    s)
	val="$OPTARG"
	read -p "Enter Username: " user
	read -s -p "Enter password: " pass_
	echo " "
	check=$(python3 data.py 's' $user $pass_)
	if [ "$check" -eq 1 ];
	then
#		echo yes
	 	ip=$(python3 data.py 'ip')
#		username=$(python3 data.py 'username')
#		password=$(python3 data.py 'password')
#		eval 'sshpass -p $pass_ scp $val $user@$ip:/home/$user'
		eval 'sshpass -p $pass_ scp -r ${@:2} $user@$ip:/home/$user/Documents'
		if [ "$?" -eq 0 ];then 
			echo Transferred successfully.
		else
			echo Transfer failed.
		fi
	else
		echo Incorrect username or password.
	fi
      ;;
    h)
	echo "usage: "
	echo "-a, add a new user"
	echo "-s [file path(s)], send files to server."
	echo "-r [file path(s)], receive files from server."
	echo "-v , view your server"
      ;;
    v)
#	echo "Creating new user"
	read -p "Enter Username: " user
	read -s -p "Enter password: " pass_
	echo " "
	check=$(python3 data.py 's' $user $pass_)
	if [ "$check" -eq 1 ];
	then
		ip=$(python3 data.py 'ip')
		username=$(python3 data.py 'username')
		password=$(python3 data.py 'password')
		p="sshpass -p $pass_ ssh -o StrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $user@$ip 2>/dev/null"
#		cmd="ls -R /home/$user/Documents/ | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
#		cmd=' find /home/$user/Documents/ | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"'
		eval '$p find /home/$user/Documents/ | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/" 2>>err_logs.txt' 2>>err_logs.txt
#		eval $p find /home/$user/Documents/ -type d | awk -F'/' '{ depth=3;offset=2;str="|  ";path="";if(NF >= 2 && NF < depth + offset) {    while(offset < NF) {        path = path "|  ";        offset ++;    }    print path "|-- "$NF;}}' 2>>err_logs.txt
	else
		echo "Invalid username/password"
	fi
	;;
    r)
	val="$OPTARG"
	read -p "Enter Username: " user
	read -s -p "Enter password: " pass_
	echo " "
	check=$(python3 data.py 's' $user $pass_)
	if [ "$check" -eq 1 ];
	then
	 	ip=$(python3 data.py 'ip')
		eval 'sshpass -p $pass_ scp -r $user@$ip:/home/$user/Documents/${@:2} .'
		if [ "$?" -eq 0 ];then 
			echo Transferred successfully.
		else
			echo Transfer failed.
		fi
	else
		echo Incorrect username or password.
	fi
      ;;

    ?)
      echo "script usage: $(basename \$0) [-a] [-h] [-v] [-s filepaths] [-r filepaths]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
#p="sshpass -p $password ssh -o StrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $username@$ip 2>/dev/null "
#cmd="echo $password | sudo -S useradd -m -p "
#eval '$p $cmd 2>>err_logs.txt'

