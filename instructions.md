# build the container image. To be done after code changes
# We will do code mapping later
bash build.sh

# The following command runs the RDP server on port 3389
bash run.sh

# The following command shows the logs from the container
bash xrdp-logs.sh

## Now connect using an rdp client to the RDP server