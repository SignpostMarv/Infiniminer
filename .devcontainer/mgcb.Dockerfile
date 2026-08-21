FROM dhi.io/dotnet:10-sdk

# we're mounting just the mgcb directory as app here
ENV HISTFILE=/app/mgcb/.bash_history

USER nonroot

RUN dotnet tool install -g dotnet-mgcb

ENV PATH="${PATH}:/home/nonroot/.dotnet/tools"
