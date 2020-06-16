FROM python:3.7-alpine
LABEL maintainer="Kyle Haptonstall"

# Tell Python to run in unbuffered mode - recommended for Python in Docker containers.
ENV PYTHONUNBUFFERED 1

# Copy the local requirements file onto the Docker image
COPY ./requirements.txt /requirements.txt
# Use alpine's package manager (apk) to add postgres. Use --no-cache to avoid storing extra files on our Docker container.
RUN apk add --update --no-cache postgresql-client
# Install necessary dependencies temporarily
RUN apk add --update --no-cache --virtual .tmp-build-deps \
    gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
# Delete the above temperorary dependencies
RUN apk del .tmp-build-deps

# Create empty folder on our Docker image call /app
RUN mkdir /app
# Switch into the /app folder
WORKDIR /app
# Copy our app folder from our local machine onto the Docker image
COPY ./app /app

# Create a user that will run our application using Docker
RUN adduser -D user
# Switch to that user
USER user