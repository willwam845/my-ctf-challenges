FROM python:slim-bullseye AS app
RUN pip install --no-cache pycryptodome

FROM pwn.red/jail
COPY --from=app / /srv
COPY server.py /srv/app/run
COPY flag.txt key.txt /srv/app/
ENV JAIL_TIME=10800 JAIL_MEM=40M JAIL_CPU=1000