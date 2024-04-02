# oasis-container

[![build-oasis-container](https://github.com/frap129/oasis-container/actions/workflows/build.yml/badge.svg)](https://github.com/frap129/oasis-container/actions/workflows/build.yml) 

[Oasis Linux](https://github.com/oasislinux) packaged as an OCI container for easier experimentation. With the default configuration, the container is ~63MB, making is an amazingly tiny container base.

Thank you to @michaelforney and the rest of the @oasislinux contributors for this awesome distro!


## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/frap129/oasis
