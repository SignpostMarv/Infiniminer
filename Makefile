ARCHIVE_RESTORE = docker run --rm -it \
		-v /app/:/app/ \
		-v /archive/infiniminer/:/archive/infiniminer/ \
		-v /home/vscode/.gitconfig:/home/vscode/.gitconfig:ro \
		-v ./.devcontainer/.ash_history:/home/vscode/.ash_history \
		-e git_init_defaultbranch=$${git_init_defaultbranch:-main} \
		-w /app/archive-restore/ \
		-u vscode \
		archive-restore

devcontainer--postAttachCommand: \
	docker-build
	@echo "done setting up"

docker--build: \
	archive-restore--build \
	echo "done building docker images"

archive-restore--build:
	@docker build -t archive-restore -f .devcontainer/archive-restore.Dockerfile ./.devcontainer/.empty-directory-on-purpose

archive-restore--init:
	@sudo chown -R vscode:vscode /archive/infiniminer/
	@touch ./.devcontainer/.ash_history

.PHONY: archive-restore
archive-restore: archive-restore--init
	@${ARCHIVE_RESTORE} \
		sh

svn2git: archive-restore--init
	@${ARCHIVE_RESTORE} \
		make svn2git

build--clean:
#	@cd /app/csharp/ && rm -fr \
#		./bin/win-x64/ \
#		./bin/Content/ \
#		./bin/runtimes/ \
#		./bin/*.dll \
#		./bin/*.exe \
#		./bin/*.config \
#		./bin/*.pdb \
#		./bin/*.xml
	@sudo chown -R vscode:vscode /app/csharp/
#	@rm -fr /app/csharp/vendor/*
#	@dotnet restore /app/csharp/code/

build--InfiniminerClient:
	@dotnet build \
		/app/csharp/source/Infiniminer/Infiniminer.Client.DesktopGL/Infiniminer.Client.DesktopGL.csproj

build--InfiniminerServer:
	@dotnet build \
		/app/csharp/source/Infiniminer/Infiniminer.Server/Infiniminer.Server.csproj

publish--InfiniminerClient:
	@dotnet publish \
		/app/csharp/source/Infiniminer/Infiniminer.Client.DesktopGL/Infiniminer.Client.DesktopGL.csproj

publish--InfiniminerServer:
	@dotnet publish \
		/app/csharp/source/Infiniminer/Infiniminer.Server/Infiniminer.Server.csproj

build: \
	build--clean \
	build--mgcb \
	build--InfiniminerClient \
	build--InfiniminerServer
	echo "done building"

publish--clean:
	@rm -fr /app/csharp/bin/win-x64/

publish: \
	publish--clean \
	build--mgcb \
	publish--InfiniminerClient \
	publish--InfiniminerServer
	echo "done building"
