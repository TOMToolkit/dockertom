FROM python:3.7

WORKDIR /tom

RUN pip install --no-cache-dir \
	gevent \
	gunicorn \
	numpy \
	tomtoolkit \
	whitenoise

COPY . .

CMD [ "gunicorn", "--bind=0.0.0.0:8080", "--worker-class=gevent", "--workers=4", "--timeout=300", "--access-logfile=-", "--error-logfile=-", "dockertom.wsgi:application" ]
