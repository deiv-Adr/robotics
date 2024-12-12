import subprocess
import time

# Define the source and destination paths
source_path = '/home/user/myfile.txt'  # Path to the source file on your local machine (Linux)
destination_path = 'user@remote_host:/home/user/backup/'  # Destination path on the remote Linux machine

# Define the rsync command
rsync_command = ['rsync', '-avz', source_path, destination_path]

# Infinite loop to run rsync every 1 second
while True:
    try:
        # Run the rsync command
        subprocess.run(rsync_command, check=True)
        print(f"File synced successfully at {time.ctime()}")

    except subprocess.CalledProcessError as e:
        print(f"Error during rsync: {e}")

    # Wait for 1 second before the next sync
    time.sleep(1)
