# Derived from official mysql image (our base image)
FROM mysql:latest

ADD . /database
# Add a database
ENV MYSQL_DATABASE bd_p1

# Add the content of the sql-scripts/ directory to your image
# All scripts in docker-entrypoint-initdb.d/ are automatically
# executed during container startup
COPY ./sql-scripts/ /docker-entrypoint-initdb.d/
COPY ./iniciar_DB.sh /app

RUN sh ./iniciar_DB.sh
