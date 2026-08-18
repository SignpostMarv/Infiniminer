ARCHIVE_RESTORE = docker run --rm -it \
		-v /app/:/app/ \
		-v /archive/infiniminer/:/archive/infiniminer/ \
		-v /home/vscode/.gitconfig:/home/vscode/.gitconfig:ro \
		-v ./.devcontainer/.ash_history:/home/vscode/.ash_history \
		-e git_init_defaultbranch=$${git_init_defaultbranch:-main} \
		-w /app/archive-restore/ \
		-u vscode \
		archive-restore

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
