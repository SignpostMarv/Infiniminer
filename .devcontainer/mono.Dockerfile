FROM mono:6.12

RUN groupadd -g 1000 vscode && useradd -u 1000 -g vscode -m vscode

USER vscode

ENV HISTFILE=/app/.devcontainer/mono.bash_history
