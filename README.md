# Infiniminer

## Restoring the Infiniminer source code

Refer to [archive-restore/README.md](archive-restore/README.md)
for in-depth instructions.

This project uses devcontainers with docker-in-docker to run a custom image
in order to properly convert the archived svn repo toa pair of git
repositories.

To restore the source code archive to a pair of git repositories,
refer to [the setup notes](archive-restore/README.md#setup)
then run `make svn2git`.

### `/archive/infiniminer/git/`

This will contain the trunk and development branches of the svn repository.

### `/archive/infiniminer/wiki-git/`

This will contain the markdownified wiki files.

## Building Infiniminer

Not yet documented.
