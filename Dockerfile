# Étape 1 : Utiliser l'image de base Python
FROM python:3.9-alpine AS base

# Définir l'environnement de travail
WORKDIR /app

# Copier requirements.txt dans l'image
COPY requirements.txt .

# Installer les dépendances système nécessaires (git, etc.) et pip
RUN apk update && \
    apk add --no-cache git && \
    # Installer les dépendances Python
    pip install --no-cache-dir -r requirements.txt

FROM base AS dev
CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]

FROM base AS build
COPY . .
RUN git config --global --add safe.directory .
# Ajouter ici des commandes pour générer des fichiers nécessaires, par exemple:
RUN mkdocs build

# Étape 2 : Utiliser l'image Apache pour héberger les fichiers
FROM httpd:2.4

# Copier les fichiers générés depuis l'étape 'build' dans le répertoire d'Apache
COPY --from=build /app/site /usr/local/apache2/htdocs/
COPY httpd.conf /usr/local/apache2/conf/

# Exposer le port 80 pour Apache
EXPOSE 8000

# Commande pour démarrer Apache
CMD ["httpd-foreground"]