FROM mcr.microsoft.com/dotnet/aspnet:10.0

LABEL org.opencontainers.image.source="https://github.com/CHANGE_ME/vintagestory-pterodactyl"
LABEL org.opencontainers.image.description="Vintage Story dedicated server for Pterodactyl (x64, .NET 10)"

# Pterodactyl/Wings требования: пользователь container (UID/GID 988), домашняя директория /home/container
RUN apt-get update && apt-get install -y --no-install-recommends \
        bash curl ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -r container -g 988 && \
    useradd -u 988 -r -g container -m -d /home/container -s /bin/bash container

USER container
ENV HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash"]
