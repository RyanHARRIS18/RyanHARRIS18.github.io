#! /bin/bash
#
# Written by: Jaron and Ryan
#

# Author: Ryan
# a|A #
    function add_user () {
    #!/bin/bash
    # Script to add a user to Linux system
        read -p "Enter username : " username
        read -s -p "Enter password : " password
            
        if getent passwd "$1" >/dev/null; then
        printf 'The user %s already exists\n' "$1"
        exit 1
        else
        printf 'The user %s does not exist\n' "$1"
        useradd -m -p $password $username
            [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
        fi
        
        ## NEED TO ADD CONDITION SO ONLY ROOT CAN
    }



# Author: Ryan
#d|D#
    function delete_user () {
        echo "delete user function. This must be Done in Root"
        read -p "Enter username : " username
        
        userdel -r $username
        
        [ $? -eq 0 ] && echo "User has been deleted from system!" || echo "Failed to delete a user!"
    }

    
# Author: Ryan
# h|H #
    function print_usage () {
    echo -e "Usage: myuser.sh -a <login> <passwd> <shell> - add a user account
    myuser.sh -d <login> - remove a user account
    myuser.sh -f <file> - add user accounts from file <file>
    myuser.sh -F <file> - remove user accounts from file <file>
    myuser.sh -h - display this usage message
    myuser.sh -s <login> <shell> - change the shell to <shell> for
    <login>-->\c"
    }


# Author: 
#s|S#
    function change_shell () {
    echo "change shell function"
    }

# Author: 
# f 
function add_user_from_file () {
echo "add user from file"
}

# Author: 
# F
function delete_user_from_file () {
echo "delete user from file"
}

# Author: 
function validate_file () {
echo "validate file"
}

# Author: Ryan
function parse_command_options () {
clear
echo "Enter a command"
read ANSWER
case $ANSWER in
##########################################################
    a|A )
	echo "Add a User Account (a)"
		add_user
		;;
		
##########################################################		
	d|D ) 
	echo "Remove a User Account(d)"
		delete_user
		;;
		
##########################################################	
	f )
        echo "Add a User From a File (f)"
		add_user_from_file
		;;
		
##########################################################		
	F )
        echo "Remove user accounts from a File (F)"
		delete_user_from_file 
		;;
		
##########################################################
	h|H )
        echo "Display usage message (h)"
		print_usage
		;;

##########################################################		
    q|Q ) 
        echo "Exiting, goodbye"
        exit
        ;;
##########################################################	
	s|S )
        echo "Change to another Shell, specify the User(s)"
		change_shell
		;;
        #Quit (q)
##########################################################
*) echo "ERROR: Invalid option: "
echo "You must enter either the letter (a/d/f/F/h/s/q)."
sleep 4
;;
esac
}


parse_command_options 



