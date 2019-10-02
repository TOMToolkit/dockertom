# dockertom
This is a sample TOM to show how it can be used with
[Docker](https://www.docker.com/).

The TOM was created by following the
[getting started guide](https://tom-toolkit.readthedocs.io/en/stable/introduction/getting_started.html)
with the credentials:
- User: `tom-user`
- Password: `password`

and the modifications laid out below.

Dockerizing existing projects will require some project specific modifications
that differ slightly from this example.

## Dependencies
- [Docker](https://www.docker.com/)
- [gevent](http://www.gevent.org/)
- [Gunicorn](https://gunicorn.org/)
- [WhitNoise](http://whitenoise.evans.io/)
- [Make](https://www.gnu.org/software/make/) (optional)

## Modifications
All of the modifications listed below have already been made to this repository
**except** [Create database directory](#Create-database-directory).

## Create database directory
Since Docker containers are ephemeral and the TOM has a database that should be
persisted, we need to put our database in a
[volume](https://docs.docker.com/storage/volumes/).

First, we'll create a directory in our project that we can use as a volume in
our container:
```
mkdir storage
```

## Change database path
Now we need to tell the TOM where to find the database by updating an element in
the `DATABASES` section of
[settings.py](./dockertom/settings.py):
```
'NAME': os.path.join(BASE_DIR, 'storage', 'db.sqlite3'),
```

## Migrate database
Now that we've updated the location of where the TOM will look for the database,
let's migrate the databases in the `storage` directory:
```
./manage migrate
```

## Web server
In order to allow others to access our TOM, we need to serve it with a web
server. [Gunicorn](https://gunicorn.org/) is a popular Python web server that
we'll use in this example.

```
pip install gunicorn gevent
```

## Serve static files
Although we have setup a web server for our TOM, it's not able to server static
files to users (e.g. images). We can serve static files using
[WhiteNoise](http://whitenoise.evans.io/).

Note that other applications are better suited to serve static files such as
[Nginx](https://www.nginx.com/) when a TOM is deployed using system packages
(e.g. [DNF](https://fedoraproject.org/wiki/DNF?rd=Dnf),
[apt-get](https://wiki.debian.org/apt-get)) or container orchestration
(e.g. [Kubernetes](https://kubernetes.io/)).

```
pip install whitenoise
```
