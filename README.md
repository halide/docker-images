# Halide CI Docker images

This repository contains a number of Dockerfiles that are used by Halide's
continuous integration system to speed up packaging (and maybe someday testing)
workflows.

At the moment, the six-hour time limit on GitHub Actions makes the i686 and
aarch64 copies of `manylinux2014-*-llvm` unable to be built and deployed
automatically. Instead, until a cross-compiling solution can be devised, these
images will have to be constructed and pushed locally.

The steps for doing this are, assuming qemu user static has been set up
already, the following:

  1. Create a [GitHub token] with `write:packages` permissions.
  2. Store the token in an environment variable, `GITHUB_TOKEN`.
  3. Log in to the Container Registry Service via `echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin`
  4. Run the `./build-images.sh` script. The `reset-docker.sh` script will
     delete **everything** from your local Docker instance, so be warned. But
     it can come in handy when disk space is an issue.
  5. Push the images via `docker push ghcr.io/halide/manylinux2014_aarch64-llvm:15.0.1`,
     `docker push ghcr.io/halide/manylinux2014_i686-llvm:15.0.1`, and 
     `docker push ghcr.io/halide/manylinux2014_x86_64-llvm:15.0.1`.

See the docs for more details: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry

[GitHub token]: https://github.com/settings/tokens/new
