# Infrastructure continuous integration Docker image

Software useful for running infrastructure-specific continuous integration jobs
at Democracy Works.

## Software

| Name | Version |
| --- | --- |
| AWS CLI | v2.1.30 |
| AWS SAM CLI | v1.20.0 |
| `kubectl` | v1.19.8 |
| `kubeval` | v0.15.0 |
| Terraform | v0.14.8 |

Other supporting software packages include:

- curl
- git
- jq
- make

## Versioning

Major version numbers on the image tag indicate a potentially-breaking change to
the software contained within. Minor version numbers indicate software additions
or package upgrades believed to be compatible. Patch version number changes
indicate a bugfix related to the container itself.

## Usage

```sh
docker run -it --rm 009999273940.dkr.ecr.us-west-2.amazonaws.com/democracyworks/infrastructure-ci aws --version
docker run -it --rm 009999273940.dkr.ecr.us-west-2.amazonaws.com/democracyworks/infrastructure-ci kubectl version --client
docker run -it --rm 009999273940.dkr.ecr.us-west-2.amazonaws.com/democracyworks/infrastructure-ci kubeval --version
docker run -it --rm 009999273940.dkr.ecr.us-west-2.amazonaws.com/democracyworks/infrastructure-ci terraform version
docker run -it --rm 009999273940.dkr.ecr.us-west-2.amazonaws.com/democracyworks/infrastructure-ci sam --version
```

## Configuration

| Variable | Description | Default |
| --- | --- | --- |
| `DOCKER_IMAGE` | Docker image to build | `009999273940.dkr.ecr.us-west-2.amazonaws.com/democracyworks/infrastructure-ci` |
| `DOCKER_TAG` | Docker image tag | `v3.1.0` |

## Development

1. Update versions of dependencies in the `Makefile`.
2. Run `make build` to test your changes.

## Releasing

1. Commit your changes to `main`. A continuous integration process will build,
   tag, and push a new image to the image repository.
