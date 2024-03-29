[![pipeline status](https://gitlab.conarx.tech/containers/celery/badges/main/pipeline.svg)](https://gitlab.conarx.tech/containers/celery/-/commits/main)

# Container Information

[Container Source](https://gitlab.conarx.tech/containers/celery) - [GitHub Mirror](https://github.com/AllWorldIT/containers-celery)

This is the Conarx Containers Celery image, it provides the Celery distributed asynchronous task queue/job system.

Support is included for downloading and installing requirements listed in `requirements.txt` and persisting these across container
restarts.

Celery may be run in two modes, either `worker` or `beat`.


# Mirrors

|  Provider  |  Repository                            |
|------------|----------------------------------------|
| DockerHub  | allworldit/celery                      |
| Conarx     | registry.conarx.tech/containers/celery |



# Conarx Containers

All our Docker images are part of our Conarx Containers product line. Images are generally based on Alpine Linux and track the
Alpine Linux major and minor version in the format of `vXX.YY`.

Images built from source track both the Alpine Linux major and minor versions in addition to the main software component being
built in the format of `vXX.YY-AA.BB`, where `AA.BB` is the main software component version.

Our images are built using our Flexible Docker Containers framework which includes the below features...

- Flexible container initialization and startup
- Integrated unit testing
- Advanced multi-service health checks
- Native IPv6 support for all containers
- Debugging options



# Community Support

Please use the project [Issue Tracker](https://gitlab.conarx.tech/containers/celery/-/issues).



# Commercial Support

Commercial support for all our Docker images is available from [Conarx](https://conarx.tech).

We also provide consulting services to create and maintain Docker images to meet your exact needs.



# Environment Variables

Additional environment variables are available from...
* [Conarx Containers Postfix image](https://gitlab.conarx.tech/containers/postfix)
* [Conarx Containers Alpine image](https://gitlab.conarx.tech/containers/alpine)


## CELERY_APP

Celery application, defaults to `celery_app.celery_app`.


## CELERY_INSTANCE_TYPE

Celery instance type, either `worker` (default) or `beat`.


## CELERY_LOG_LEVEL

Celery log level. eg. "debug"



# Volumes


## /app

Application directory.



# Files & Directories


## /app/.venv/

Virtual environment for the application which must be created beforehand. The requirement `celery` must be included.

This can be created with...

```sh
docker run -it --rm \
    -v /path/to/venv:/app/.venv \
    -v /path/to/app/requirements.txt:/app/requirements.txt \
    allworldit/celery \
    /bin/sh -c "python -m venv /app/.venv; . /app/.venv/bin/activate; pip install 'celery'; pip install --requirement /app/requirements.txt"
```

In order to run flower, take note of the flower package below which is added...

```sh
docker run -it --rm \
    -v /path/to/venv:/app/.venv \
    -v /path/to/app/requirements.txt:/app/requirements.txt \
    allworldit/celery \
    /bin/sh -c "python -m venv /app/.venv; . /app/.venv/bin/activate; pip install 'celery' 'flower'; pip install --requirement /app/requirements.txt"
```


# Health Checks

Health checks are done by the underlying images as Celery doesn't listen on any ports or provide any real sort of means to
determine health.
