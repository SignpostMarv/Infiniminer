# Archive Restoration of Infiniminer source code

## Setup

1. Get an IDE that supports devcontainers
2. clone this repo
3. add docker volumes
	- `infiniminer-archive`
4. open your clone in the IDE referenced in step 1
5. edit [users.txt](users.txt) to map the svn authors to users on your git host of choice

## svn2git

1. Perform the steps referenced in [setup](#Setup)
2. run `make svn2git`
3. run `cd /archive/infiniminer/git/`

You should now be able to set the remote of your git host of choice & push the repository up.
