#! /bin/bash
#
# Written by: Jaron and Ryan
#

# Author: Ryan
# a|A #
    function add_user () {
    #!/bin/bash
    # Script to add a user to Linux system        
   
#     read -p "Enter username : " username
#     read -s -p "Enter password : " password
      echo "--------------------------"
    ls /home
    echo "---------------------------"
   
        egrep -i "^useraccount:" /etc/passwd;
        if [ $? -eq 0 ]; then
        echo "User $1 Already Exists"
       
        else
        echo "Adding User $1..."
         useradd -m -p $2 $1
            [ $? -eq 0 ] && echo "User $1 has been added to system!" || echo "Failed to add $1 user!"
        fi
       
      echo "--------------------------"
      ls /home
      echo "---------------------------"
    }



# Author: Ryan
#d|D#
    function delete_user() {
 
    echo "--------------------------"
    ls /home
    echo "---------------------------"
   
   
        egrep -i "^useraccount:" /etc/passwd;
        if [ $? -eq 0 ]; then
        echo "User $1 does not Exists"
        else
        echo "Deleting user $1 from system..."
        fi
        userdel -r $1
        [ $? -eq 0 ] && echo "User $1 been deleted from system!" || echo "Failed to delete a user!"
    echo "List of Users"
    echo "--------------------------"
    ls /home
    echo "---------------------------"
    }  
   
# Author: Ryan
# h|H #
    function print_usage() {
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
    function change_shell() {
    egrep -i "^useraccount:" /etc/passwd;
    if [ $? -eq 0 ]; then
     echo "User does not Exist"
    
    elses
    echo "User $1 Exists"
    echo "Switching $1 and shell to $2"
    usermod --shell $2 $1
    fi
	}
	
s
# Author:
# f
function add_user_from_file () {
echo "add user from file"
}

# Author:
# F
function delete_user_from_file () {
echo "--------deleting user from file------"
}

# Author:
# function validate_file () {
# echo "validate file"
# }

# Author: Ryan
function parse_command_options () {

case $1 in
##########################################################
-a|-A )
echo "-------Adding User Account (a)--------"

add_user "$2" "$3"
;;

##########################################################
-d|-D )
echo "-------Remove a User Account(d)-------"
delete_user "$2"
;;

##########################################################
# f )
#         echo "Add a User From a File (f)"
# add_user_from_file
# ;;

####################################################
# F )
#         echo "Remove user accounts from a File (F)"
# delete_user_from_file
# ;;

##########################################################
-h|-H )
        echo "Display usage message (h)"
print_usage
;;

##########################################################
-q|-Q )
        echo "Exiting, goodbye"
        exit
        ;;
##########################################################
-s|-S )
echo "Change to another Shell"
change_shell "$2" "$3"
;;
        #Quit (q)
##########################################################
*) echo "ERROR: Invalid option: "
echo "Usage: myuser.sh -a <login> <passwd> <shell> - add a user account
    myuser.sh -d <login> - remove a user account
    myuser.sh -f <file> - add user accounts from file <file>
    myuser.sh -F <file> - remove user accounts from file <file>
    myuser.sh -h - display this usage message
    myuser.sh -s <login> <shell> - change the shell to <shell> for
    <login>-->\c"
sleep 4
;;
esac
}


parse_command_options "$1" "$2" "$3" "$4"
