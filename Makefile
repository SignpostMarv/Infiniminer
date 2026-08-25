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

build--mgcb--fonts:
	@if [ ! -f "/app/mgcb/04b_03b.zip" ]; then wget -P /app/mgcb/ http://www.dsg4.com/04/extra/bitmap/stuff/04b_03b.zip; fi
	@echo "99d2ba8374b335268382f81a9bdd4a2690422e3c57cd999247ea74489b747bf15d314c0e6ba2022bcaad44fb9264ff43be2692ed0751ecd39a8e16d61de470d9 */app/mgcb/04b_03b.zip" | shasum -a 512 -b -c
	@if [ ! -f "/app/mgcb/04b_08.zip" ]; then wget -P /app/mgcb/ http://www.dsg4.com/04/extra/bitmap/stuff/04b_08.zip; fi
	@echo "c2bb7db01f98f1ac75ffc38578bf8d62c8ce2f58a347c82e436992be02a0942ce3d138f2463f14569c50f9b7947a0438a822676dcc2f14f08935ea7cf6e1564b */app/mgcb/04b_08.zip" | shasum -a 512 -b -c
	@rm -f \
		/app/csharp/code/InfiniminerClient/Content/*.otf \
		/app/csharp/code/InfiniminerClient/Content/*.ttf \
		/app/csharp/code/InfiniminerClient/Content/*.TTF
	@unzip -j /app/mgcb/04b_03b.zip 04B_03B_.TTF -d /app/csharp/code/InfiniminerClient/Content/
	@mv /app/csharp/code/InfiniminerClient/Content/04B_03B_.TTF /app/csharp/code/InfiniminerClient/Content/04b03b.ttf
	@unzip -j /app/mgcb/04b_08.zip 04B_08__.TTF -d /app/csharp/code/InfiniminerClient/Content/
	@mv /app/csharp/code/InfiniminerClient/Content/04B_08__.TTF /app/csharp/code/InfiniminerClient/Content/04b08.ttf

build--mgcb: build--mgcb--fonts
	@dotnet tool install -g dotnet-mgcb
	@/app/mgcb/build.sh
	@cd /app/csharp/bin/Content/ && \
		mv 04b03b.xnb font_04b03b.xnb && \
		mv 04b08.xnb font_04b08.xnb

build--clean:
	@cd /app/csharp/ && rm -fr \
		./bin/win-x64/ \
		./bin/Content/ \
		./bin/runtimes/ \
		./bin/*.dll \
		./bin/*.exe \
		./bin/*.config \
		./bin/*.pdb \
		./bin/*.xml
	@sudo chown -R vscode:vscode /app/csharp/
	@rm -fr /app/csharp/vendor/*
	@dotnet restore /app/csharp/code/

build--InfiniminerClient:
	@dotnet build \
		/app/csharp/code/InfiniminerClient/InfiniminerClient.csproj

build--InfiniminerServer:
	@dotnet build \
		/app/csharp/code/InfiniminerServer/InfiniminerServer.csproj

publish--InfiniminerClient:
	@dotnet publish \
		/app/csharp/code/InfiniminerClient/InfiniminerClient.csproj

publish--InfiniminerServer:
	@dotnet publish \
		/app/csharp/code/InfiniminerServer/InfiniminerServer.csproj

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
