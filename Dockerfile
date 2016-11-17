FROM python:3.5

# Set the file maintainer (your name - the file's author)
MAINTAINER Olivier Chantereau

# Set env variables used in this Dockerfile (add a unique prefix, such as DOCKYARD)
# Local directory with project source
ENV DOCKER_SRC=/DockerContent
# Directory in container for all project files
ENV DOCKER_SRVHOME=/srv
# Directory in container for project source files
ENV DOCKER_SRVPROJ=/srv/project

# Update the default application repository sources list
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y \
    python \
    python-pip \
    python-django

# Create application subdirectories
WORKDIR $DOCKER_SRVHOME
RUN mkdir media static logs
VOLUME ["$DOCKER_SRVHOME/media/", "$DOCKER_SRVHOME/logs/"]

# Copy application source code to SRCDIR
COPY $DOCKER_SRC $DOCKER_SRVPROJ

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r $DOCKER_SRVPROJ/requirements.txt

EXPOSE 8000

# Copy entrypoint script into the image
WORKDIR $DOCKER_SRVPROJ
COPY ./../docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
