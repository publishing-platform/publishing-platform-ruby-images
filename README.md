# Publishing Platform Ruby Images
OCI container images for building and running production Ruby applications on Kubernetes.

## What's in this repo

The publishing-platform-ruby-images repository defines [OCI] container images for building and running production Ruby applications on Kubernetes.

- `publishing-platform-ruby-base` is a base image for production application containers; it provides:
  - a Ruby runtime that can run as an unprivileged user with a read-only filesystem
  - database client libraries
  - a Node.js runtime

- `publishing-platform-ruby-builder` is for building application container images; it provides the same as `publishing-platform-ruby-base` plus:
  - a C/C++ toolchain and various build tools and utilities
  - Yarn, for building/installing Node.js package dependencies
  - configuration to speed up and optimise building Ruby applications

[OCI]: https://opencontainers.org/


## Usage

Use the two images in your app's Dockerfile.

Specify the image tag that corresponds to the `<major>.<minor>` Ruby version that your application needs.


```dockerfile
ARG ruby_version=3.2
ARG base_image=ghcr.io/publishing-platform/publishing-platform-ruby-base:$ruby_version
ARG builder_image=ghcr.io/publishing-platform/publishing-platform-ruby-builder:$ruby_version

FROM $builder_image AS builder

# your build steps here

FROM $base_image

# your app image steps here
```

## Supported tags

Our version maintenance policy is similar to [upstream](https://www.ruby-lang.org/en/downloads/branches/)

See [build-matrix.json](build-matrix.json#L2) for the list of Ruby versions we currently support.

> [!IMPORTANT]
> Please do not attempt to specify the Ruby patch version. See [below](#if-you-suspect-a-bug) for alternatives.


## Common problems and resolutions

`ERROR: failed to solve: cannot copy to non-directory: /var/lib/docker/overlay2/.../merged/app/tmp`

Add `tmp/` to your `.dockerignore`. This is necessary because we symlink
`$APP_HOME/tmp` to `/tmp` as a workaround for some badly-behaved gems that
assume they can write to `Path.join(Rails.root, 'tmp')` so that we can run with
`readOnlyRootFilesystem`.


## Maintenance


### Add or update a Ruby version

The file [build-matrix.json](/build-matrix.json) defines the Ruby versions and image tags that we build.

The `checksum` field is currently the SHA-256 hash of the Ruby source tarball. We verify this in the build.

See [Ruby Releases](https://www.ruby-lang.org/en/downloads/releases/) for the list of available Ruby tarballs and their SHA digests.
