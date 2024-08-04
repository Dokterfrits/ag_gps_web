#!/bin/bash

# Run migrations
python manage.py migrate

# Create superuser if it doesn't exist
python manage.py shell <<EOF
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin')
EOF

# Run the Django server
exec "$@"