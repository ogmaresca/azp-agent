FROM microsoft/vsts-agent:ubuntu-16.04-standard

# Install Docker

# Install Docker
RUN apt-get update \
 && apt-get install -y --install-recommends \
  docker.io=18.09.5-0ubuntu1~18.04.2 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*

COPY --from=gmaresca/docker-in-docker:18.09 /lib/systemd/system/docker.service /lib/systemd/system/docker.service

COPY --from=gmaresca/docker-in-docker:18.09 /etc/docker/daemon.json /etc/docker/daemon.json

COPY --from=gmaresca/docker-in-docker:18.09 /bin/entrypoint.sh /bin/start-docker.sh
RUN chmod +x /bin/start-docker.sh

WORKDIR /azp

# https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops
COPY start.sh /azp/start.sh
RUN chmod +x /azp/start.sh

CMD ["/bin/start-docker.sh", "/azp/start.sh"]
