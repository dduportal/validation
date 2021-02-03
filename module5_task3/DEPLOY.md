# Deployment

## Deployment Artifacts

* Download the ZIP archive named `awesome-website.zip`
  associated with the tag or release you want
* Unzip the archive and load it into Docker:

```shell
unzip ./awesome-website.zip # Creates docker-image.tar
docker load docker-image.tar
```

## Start / Stop the application

* Use the command `make run` to start the application
* Use the command `make stop` to stop the application

## Configuration

How to customize where are written the application’s log?

## Healthchecks

How to “quickly” verify that the application is running (healthcheck)?
