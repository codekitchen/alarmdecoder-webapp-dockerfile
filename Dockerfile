FROM python:2.7-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    # this list of deps is taken from the alarmdecoder README, with a few removed
    sendmail libffi-dev build-essential libssl-dev curl libpcre3-dev libpcre++-dev zlib1g-dev libcurl4-openssl-dev autoconf automake avahi-daemon locales dosfstools sqlite3 git sudo \
 && rm -rf /var/lib/apt/lists/*

# Sane defaults for pip
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on

RUN useradd -ms /bin/bash alarmdecoder \
 && adduser alarmdecoder sudo

RUN pip install gunicorn --upgrade

RUN cd /opt \
 && git clone http://github.com/nutechsoftware/alarmdecoder-webapp.git

WORKDIR /opt/alarmdecoder-webapp

RUN pip install -r requirements.txt

RUN mkdir instance \
 && chown -R alarmdecoder:alarmdecoder .

USER alarmdecoder

RUN python manage.py initdb

# sqlite db is stored here
VOLUME /opt/alarmdecoder-webapp/instance
EXPOSE 8000

CMD ["gunicorn", "-b", "0.0.0.0:8000", "wsgi:application"]
