# Infrastructure continuous integration Docker image

Software useful for running continuous integration jobs at Democracy Works.

## Software

| Name | Version |
| --- | --- |
| AWS CLI | v1.18.54 |
| AWS SAM CLI | v0.48.0 |
| Terraform | v0.12.25 |

Other supporting software packages include:

- curl
- jq

## Versioning

Major version numbers on the image tag indicate a potentially-breaking change to
the software contained within. Minor version numbers indicate software additions
or package upgrades believed to be compatible. Patch version number changes
indicate a bugfix related to the container itself.

## Usage

```sh
docker run -it --rm quay.io/democracyworks/infrastructure-ci aws --version
docker run -it --rm quay.io/democracyworks/infrastructure-ci terraform version
docker run -it --rm quay.io/democracyworks/infrastructure-ci sam --version
```

## Configuration

| Variable | Description | Default |
| --- | --- | --- |
| `DOCKER_IMAGE` | Docker image to build. | `quay.io/democracyworks/infrastructure-ci` |

## Development

1. Update versions of dependencies in the `Makefile`.
2. Run `make build` to test your changes.

## Releasing

1. Commit your changes to `master`. A continuous integration process will build,
   tag, and push a new image to the image repository.
