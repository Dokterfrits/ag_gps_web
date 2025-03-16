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
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# copy the entire project
COPY . .

# copy entrypoint script and make it executable
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# add non-root user
RUN adduser --disabled-password --gecos '' webuser

# Change ownership of files
RUN chown -R webuser:webuser ./
RUN chown -R webuser:webuser ./data

# create necessary directories
RUN mkdir -p /vol/webviewer/static
RUN mkdir -p /vol/webviewer/media

# Change ownership of /vol
RUN chown -R webuser:webuser /vol
RUN chmod -R 755 /vol

# switch to non-root user
USER webuser

# Expose port 8000
EXPOSE 8000

# Set entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]

# define the default command to run
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
