#!/usr/bin/env bash
# exit on error
set -o errexit

pip install -r requirements.txt

python manage.py collectstatic --no-input
python manage.py migrate

# Crear superusuario si no existe
python manage.py createsuperuser --no-input --email "$DJANGO_SUPERUSER_EMAIL" --username "$DJANGO_SUPERUSER_USERNAME" || true

# Establecer la contraseña del superusuario
python manage.py shell <<EOF
from django.contrib.auth import get_user_model
User = get_user_model()
user = User.objects.filter(username="$DJANGO_SUPERUSER_USERNAME").first()
if user:
    user.set_password("$DJANGO_SUPERUSER_PASSWORD")
    user.save()
    print("Contraseña del superusuario actualizada.")
EOF
