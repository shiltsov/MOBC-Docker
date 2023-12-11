FROM python:3.11-slim
LABEL maintainer="sda@asperito.ru"

COPY sql/* /
COPY main.py /
COPY requirements.txt /
COPY .env /
COPY start.sh /

RUN apt update && apt install postgresql -y && apt install postgresql-client -y && apt install systemctl -y && apt install mc -y

USER postgres

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker 
RUN    /etc/init.d/postgresql start &&\
    psql -f create.sql docker 

RUN echo "listen_addresses='*'" >> /etc/postgresql/15/main/postgresql.conf

USER root
RUN pip install -r /requirements.txt

EXPOSE 5555


CMD ["bash","start.sh"]
