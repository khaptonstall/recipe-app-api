FROM python:3.7-alpine
LABEL maintainer="Kyle Haptonstall"

# Tell Python to run in unbuffered mode - recommended for Python in Docker containers.
ENV PYTHONUNBUFFERED 1

# Copy the local requirements file onto the Docker image
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

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