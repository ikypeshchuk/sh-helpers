#!/bin/bash

# Check for the presence of arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Get the username from the argument
username="$1"


# Prompt for the user's password without displaying it
echo -n "Enter password for user '$username': "
read -sr password
echo

# Prompt to confirm the password
echo -n "Confirm password for user '$username': "
read -sr confirm_password
echo

# Check if passwords match
if [ "$password" != "$confirm_password" ]; then
    echo "Passwords do not match. User creation aborted."
    exit 1
fi

# Check if a group with the same name as the username exists
if grep -q "^$username:" /etc/group; then
    echo "Group '$username' already exists."
else
    # Create a group with the username
    sudo groupadd "$username"
    echo "Group '$username' created."
fi

# Create a user with the specified username and home directory
sudo useradd -m -g "$username" -s /bin/bash "$username"
# Set the user's password
echo "$username:$password" | sudo chpasswd
echo "User '$username' created."

# Add the user to the 'sudo' group
sudo usermod -aG sudo "$username"
echo "User '$username' added to the 'sudo' group."

# Add the user to the 'www-data' group
sudo usermod -aG www-data "$username"
echo "User '$username' added to the 'www-data' group."

# Display user and group information
echo "Username: $username"
echo "Group: $username"
