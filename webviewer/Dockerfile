# pull official base image
FROM python:3.8-slim

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# copy project
COPY requirements.txt ./requirements.txt

# install dependencies
# RUN apt-get install -y libjpeg-dev zlib1g-dev gcc
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# copy project
COPY . .

COPY scripts /scripts

## Run collectstatic during the build phase
#RUN python manage.py collectstatic --noinput

RUN adduser --disabled-password --gecos '' webuser

# RUN chmod 755 ./data/database
# RUN chmod -R 755 ./data/media
RUN chown -R webuser:webuser ./
RUN chown -R webuser:webuser ./data
# RUN chown webuser:webuser ./data/database


RUN chmod +x /scripts/*

RUN mkdir -p /vol/webviewer/static
RUN mkdir -p /vol/webviewer/media

# ADD ./data/media /vol/webviewer/media/

RUN chown -R webuser:webuser /vol
RUN chmod -R 755 /vol

# switch to non-root user
USER webuser

# Make port 8000 available to the world outside this container.
EXPOSE 8000

# ENTRYPOINT ["/scripts/entrypoint.sh"]