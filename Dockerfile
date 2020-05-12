# Use the official Docker Hub Ubuntu 16.04 Image
FROM ubuntu:16.04

# Update the base image
RUN apt-get update && apt-get dist-upgrade -y && apt-get autoremove --purge -y

# Install impitool and curl
RUN apt-get install curl ipmitool git -y

# Copy the entrypoint script into the container
COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh

# Load the entrypoint script to be run later
ENTRYPOINT ["/docker-entrypoint.sh"]
