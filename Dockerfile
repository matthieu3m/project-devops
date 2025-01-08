# Pour builder ou exécuter la doc
FROM python:alpine AS base
WORKDIR /app
COPY requirements.txt .
RUN apk add --no-cache git
RUN pip install -r requirements.txt
RUN pip install --upgrade mkdocs-material


# Stage to allow init mkdocs project
FROM base as init
CMD ["mkdocs", "new", "example"]

# Stage to dev locally, pas de copy car on bind mount
FROM base as dev
RUN apk add --no-cache neovim
CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]

# On build la doc en elle même
FROM base as build
COPY . .
CMD ["mkdocs", "build"]

## Et on place ca dans le container final
#FROM nginx:alpine
#COPY --from=build /app/site /usr/share/nginx/html
FROM httpd:2.4

# Activer mpm_event
#RUN sed -i 's/#LoadModule mpm_event_module/LoadModule mpm_event_module/' /usr/local/apache2/conf/httpd.conf

COPY --from=build /app/site /usr/local/apache2/htdocs/
COPY httpd.conf /usr/local/apache2/conf/