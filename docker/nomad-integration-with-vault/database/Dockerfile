####################################################################################
#
#   file:           /db/Dockerfile
#   author:         Patrick Gryzan
#   date:           02/14/20
#   description:    Dockerfile for the Postgre data used for the deom application.
#                   It inherits frrom the latest Postgres container.
#                   It sets the username, password and database name.
#                   Default information is populated on startup from populate.sql.
#
####################################################################################

FROM postgres:latest
LABEL author="Patrick Gryzan <pgryzan@hashicorp.io>"
LABEL description="This the database container of demo application"

ENV POSTGRES_DB demo
ENV POSTGRES_USER demo
ENV POSTGRES_PASSWORD demo

ADD populate.sql /docker-entrypoint-initdb.d/

EXPOSE  5432