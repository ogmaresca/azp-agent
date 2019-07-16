lint:
	helm lint charts/azp-agent

template:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl

template-no-persistence:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,azp.persistence.enabled=false,docker.persistence.enabled=false

template-no-docker:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,docker.enabled=false

template-persistence:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,azp.persistence.enabled=true,docker.persistence.enabled=true

template-combined-volume:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,azp.persistence.enabled=true,docker.persistence.enabled=true,docker.persistence.name=workspace

template-docker-no-clean:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,azp.persistence.enabled=true,docker.persistence.enabled=true,docker.clean=false

template-docker-lifecycle:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,azp.persistence.enabled=true,docker.persistence.enabled=true,docker.clean=true,docker.lifecycle.postStart.tcpSocket.port=1337

template-docker-lifecycle-fail:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,azp.persistence.enabled=true,docker.persistence.enabled=true,docker.clean=true,docker.lifecycle.postStart.exec.command={sh,-c,ls}

template-env-secret:
	helm template charts/azp-agent --set 'azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,azp.extraEnv[0].name=SUPER_SECRET_PASSWORD,azp.extraEnv[0].value=P@$$W0RD,azp.extraEnv[0].secret=true'

template-autoscaler:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,scaling.enabled=true

template-hpa:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,scaling.enabled=true,scaling.cpu=50%

template-existing-secret:
	helm template charts/azp-agent --set azp.url=https://dev.azure.com/test,azp.token=abc123def456ghi789jkl,scaling.enabled=true,azp.existingSecret=test-secret,azp.existingSecretKey=test-secret-key

test:
	make lint && \
	make template && \
	make template-no-persistence && \
	make template-no-docker && \
	make template-persistence && \
	make template-combined-volume && \
	make template-docker-no-clean && \
	make template-docker-lifecycle && \
	! make template-docker-lifecycle-fail && \
	make template-env-secret && \
	make template-autoscaler && \
	make template-hpa && \
	make template-existing-secret

test-versions:
	bash -c 'for chart in charts/*.tgz; do helm lint $$chart; done'

install:
	helm upgrade --debug --install azp-agent charts/azp-agent --set azp.url=${AZURE_DEVOPS_URL},azp.token=${AZURE_DEVOPS_TOKEN},azp.pool=${AZURE_DEVOPS_POOl},replicaCount=1,scaling.enabled=true,scaling.logLevel=trace

package:
	helm package charts/azp-agent -d charts && \
	helm repo index --merge charts/index.yaml charts
