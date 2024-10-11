# Use a more recent Node.js base image (18 or 20)
FROM node:12

# Set the JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Copy the Node.js application files
COPY nodeapp /nodeapp

# Set the working directory
WORKDIR /nodeapp

# Install Node.js dependencies
RUN npm install
# Update the package list and install OpenJDK 11 and OpenSSH
RUN apt-get update && \
    apt-get install -y openssh-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Command to run the Node.js application
CMD ["node", "app.js"]
