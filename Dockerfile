FROM debian:bookworm-slim

LABEL org.opencontainers.image.source="https://github.com/1yuk1/vintage-story-egg-s"
LABEL org.opencontainers.image.description="Vintage Story dedicated server for Pterodactyl (x64, .NET 10)"

ENV DEBIAN_FRONTEND=noninteractive

# Official yolks do not pin UID/GID. Wings injects the host pterodactyl user at runtime.
RUN useradd -m -d /home/container -s /bin/bash container

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash ca-certificates curl iproute2 tini wget \
        libgdiplus libicu72 \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q https://dot.net/v1/dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --channel 10.0 --runtime aspnetcore --install-dir /usr/share/dotnet \
    && ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm -f dotnet-install.sh

USER container
ENV USER=container HOME=/home/container DOTNET_ROOT=/usr/share/dotnet
WORKDIR /home/container

STOPSIGNAL SIGINT

COPY --chown=container:container entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/bin/bash", "/entrypoint.sh"]
