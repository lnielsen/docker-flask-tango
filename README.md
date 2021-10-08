# Docker Flask Tango

## Production use case

```
# Build the image
docker build -t inveniosoftware/inveniordm:6.0-dev .
# Run
docker run --rm -p 5000:5000 -it inveniosoftware/inveniordm:6.0-dev
curl http://127.0.0.1:5000
```

## Development use case

```
# Build the image
compose build
# Run
compose up

# At this stage you should be able to edit python files and see them update.


# Build static again - because it was built inside image, but now the shared
# volume doesnt' have it.
compose run --rm web "flask webpack create; flask install; flask webpack build"
# Run a watch - because package.json defines a script "start" that supports
# watching - still not working fully ;-)
compose run --rm web flask webpack run start

# At this stage you should be able to edit javascript files and see them update.

curl http://127.0.0.1:5000
```

## TODO

- [ ] Development vs production build differences (is this a good idea at all?)
  - Perhaps use development only locally in a compose file?
  - Do we need to explicitly build for prod and for dev - avoidable?
  - Flask devserver with debugger vs uwsgi (could just be you run the image
    differently?)
  - editable installs vs complete installs
- [ ] Add flask collect or similar for static files collection.


## How could Invenio look like:

```
invenio-cli init -c master
cd my-site
# Build the new docker image?
invenio-cli build
# Boot up all services and initialize them
invenio-cli services setup
# Run development server inside the docker image with auto load
invenio-cli run
# Watch assets and auto rebuild
invenio-cli assets watch
# Do a one-off rebuild
invenio-cli assets build
```
