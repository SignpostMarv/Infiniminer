ARCHIVE_RESTORE = docker run --rm -it \
		-v /app/:/app/ \
		-v /archive/infiniminer/:/archive/infiniminer/ \
		-v /home/vscode/.gitconfig:/home/vscode/.gitconfig:ro \
		-v ./.devcontainer/.ash_history:/home/vscode/.ash_history \
		-e git_init_defaultbranch=$${git_init_defaultbranch:-main} \
		-w /app/archive-restore/ \
		-u vscode \
		archive-restore

MONO = docker run --rm -it \
		-v /app/:/app/ \
		-v /archive/infiniminer/:/archive/infiniminer/ \
		-v /home/vscode/.gitconfig:/home/vscode/.gitconfig:ro \
		-w /archive/infiniminer/git/code/ \
		-u vscode \
		mono

archive-restore--init:
	@docker build -t archive-restore - < .devcontainer/archive-restore.Dockerfile
	@sudo chown -R vscode:vscode /archive/infiniminer/
	@touch ./.devcontainer/.ash_history

.PHONY: archive-restore
archive-restore: archive-restore--init
	@${ARCHIVE_RESTORE} \
		sh

svn2git: archive-restore--init
	@${ARCHIVE_RESTORE} \
		make svn2git

build--init:
	@docker build -t mono - < .devcontainer/mono.Dockerfile
	@sudo chown -R vscode:vscode /archive/infiniminer/
	@touch ./.devcontainer/.bash_history
	@ if [ ! -d "/archive/infiniminer/git/.git" ]; then echo "It looks like you have not run \`make svn2git\`!" >&2; exit 1; fi

build: build--init
	@${MONO} \
		bash
