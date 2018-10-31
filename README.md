# Supported tags and respective Dockerfile links
* [0.1.0](accenture/adop-gitlab:0.1.0)

# What is adop-GitLab?
adop-gitlab is a wrapper for the official GitLab image. It has primarily been built to extended configuration and integrate with the ADOP platform. GitLab is a git repository tool for source code versioning and management.

# How to use this image
This image runs a GitLab container, a PostgreSQL database in a separate container and a Redis cache in a third container.
Running the components in separate containers is the recommended way to run GitLab. An overview of the software achitecture can be found [here](https://docs.gitlab.com/ee/development/architecture.html)
The pre-requisite for running this image is to have an existing [ADOP platform](https://github.com/Accenture/adop-docker-compose) running.
The easiest for to run the adop-gitlab image is to simply clone the repository to the location you wish to launch GitLab from, export the relevant environment variables and then run the following command:
```
docker compose up -d 
```

After this GitLab will be available at: http://<HOST_IP>/gitlab

# License
Please view [licence information](LICENSES.md) for the software contained on this image.

# User feedback

## Documentation
Documentation is available in the [GitLab documentation page](https://docs.gitlab.com/omnibus/docker/#configure-gitlab).

## Issues
If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/Accenture/adop-gitlab/issues).

## Contribute
You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/Accenture/adop-gitlab/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.