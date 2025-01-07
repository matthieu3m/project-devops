# Étape 1 : Utiliser l'image de base Python
FROM python:3.12-bullseye AS build

# Définir l'environnement de travail
WORKDIR /app

# Copier requirements.txt et installer les dépendances
COPY requirements.txt .
RUN apt update && apt install -y python3-pip git
RUN pip install -r requirements.txt

COPY . .
# Ajouter ici des commandes pour générer des fichiers nécessaires, par exemple:
RUN mkdocs build

# Étape 2 : Utiliser l'image Apache pour héberger les fichiers
FROM httpd:2.4

# Copier les fichiers générés depuis l'étape 'build' dans le répertoire d'Apache
COPY --from=build /app/site /usr/local/apache2/htdocs/

# Exposer le port par défaut utilisé par Apache
EXPOSE 80
