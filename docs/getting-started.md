Here are the minimal steps to get started.

## Installation


a) Install [Nix](https://nixos.org)

=== "Linux"

    ```
    sh <(curl -L https://nixos.org/nix/install) --daemon
    ```
=== "macOS"

    ```
    sh <(curl -L https://nixos.org/nix/install)
    ```

=== "Windows (WSL2)"
   
    ```
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
    ```

=== "Docker"

    ```
    docker run -it nixos/nix
    ```

b) Install Cachix (optional, speeds up the installation by providing binaries)

=== "Newcomers"

    ```
    nix-env -iA cachix -f https://cachix.org/api/v1/install
    cachix use devenv
    ```

=== "Nix 2.4+ (flakes)"

    ```
    nix profile install github:cachix/cachix/latest
    cachix use devenv
    ```

c) Install ``devenv``

=== "Newcomers"

    ```
    nix-env -if https://github.com/cachix/devenv/tarball/v{{ devenv.version }}
    ```

=== "Newcomers (flakes)"

    ```
    nix profile install github:cachix/devenv/v{{ devenv.version }}
    ```

=== "Declaratively (non-flakes)"
    
    ```nix
    (import (fetchTarball https://github.com/cachix/devenv/archive/v{{ devenv.version }}.tar.gz))
    ```

=== "Declaratively (flakes)"

    ```nix
    inputs.devenv.url = github:cachix/devenv/v{{ devenv.version }};
    ```

## Initial setup

Given a git repository, create the initial structure:

```shell-session
$ devenv init
Creating .envrc
Creating devenv.nix
Creating devenv.yaml
Appending .devenv* to .gitignore
Done.
```

## Commands

- ``devenv ci`` builds your developer environment and makes sure that all checks pass. Useful to run in your Continuous Integration environment.
- ``devenv shell`` activates your developer environment.
- ``devenv update`` updates and pins inputs from ``devenv.yaml`` into ``devenv.lock``.
- ``devenv gc`` [deletes unused environments](garbage-collection.md) to save disk space.
- ``devenv up`` starts [processes](processes.md).

## Learn more

- About ``.envrc`` in [Automatic Shell Activation](automatic-shell-activation.md).
- About ``devenv.yaml`` in [Inputs](inputs.md) and [Composing Using Imports](composing-using-imports.md).
- About ``devenv.nix`` in the **Writing devenv.nix** section, starting with [the Basics](basics.md).
