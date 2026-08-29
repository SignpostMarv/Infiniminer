FROM mcr.microsoft.com/devcontainers/base:ubuntu

#region mgcb-related
RUN apt-get update && apt-get install -y --no-install-recommends \
	libfreetype6 \
	fontconfig \
	fonts-dejavu-core \
	& rm -rf /var/lib/apt/lists/*
#endregion

#region rust & graphics forwarding
RUN apt-get update && apt-get install -y --no-install-recommends \
	# dependencies for x86_64-unknown-linux-gnu
	g++ \
	pkg-config \
	libx11-dev \
	libasound2-dev \
	libudev-dev \
	libxkbcommon-x11-0 \
	libwayland-dev \
	libxkbcommon-dev \
	# dependencies for x86_64-pc-windows-msvc
	clang \
	llvm \
	# for getting the software rendering working
	ubuntu-wsl \
	mesa-vulkan-drivers \
	# for getting sound working
	libasound2-plugins \
	# cleaning up
	&& \
	rm -rf /var/lib/apt/lists/*

COPY asound.conf /etc/asound.conf

# fix cache perms
RUN mkdir -p /usr/local/cargo && chown -R vscode:vscode /usr/local/cargo
RUN mkdir -p /home/vscode/.cache/cargo-xwin && chown -R vscode:vscode /home/vscode/.cache/cargo-xwin
#endregion
