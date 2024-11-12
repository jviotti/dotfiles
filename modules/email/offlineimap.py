import subprocess

def get_pass(account):
    command = ["pass", "key", account]
    
    try:
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        password, stderr = process.communicate()
        
        if process.returncode == 0:
            return password.strip()
        else:
            print(f"Error retrieving password: {stderr.strip()}")
            return None
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")
        return None
