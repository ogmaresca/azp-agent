# About

A chart for Azure Pipeline agents. This chart builds off of the [vsts-agent](https://github.com/microsoft/vsts-agent-docker) images, adds docker-in-docker support, and uses the new startup script `start.sh` from [https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops).

# Installation

First, add this repo to Helm:

``` bash
helm repo add azp-agent https://raw.githubusercontent.com/ggmaresca/azp-agent/master/charts
helm repo update
```

Then use this command to install it:

``` bash
helm upgrade --install --namespace=azp azp-agent azp-agent/azp-agent --set 'azp.url=https://dev.azure.com/accountName,azp.token=AzureDevopsAccessToken'
```

If Docker is enabled, the cluster must be capable of running privileged containers.

# Configuration

The values `azp.token` and `azp.url` are required to install the chart.

If `docker.persistence.enabled` is `true` and `docker.persistence.name` is equal to `azp.persistence.name`, then the AZP workspace and the Docker workspace will use a share volume.

When adding extra environment variables, you can set `azp.extraEnv[x].secret=true` to add the environment variable to the secret. This option requires `value` to be set instead of `valueFrom`.

| Parameter                             | Description                                                             | Default                                 |
| ------------------------------------- | ----------------------------------------------------------------------- | --------------------------------------- |
| `replicaCount`                        | Number of agents to deploy.                                             | 3                                       |
| `azp.workspace`                       | The workspace folder location.                                          | /workspace                              |
| `azp.url`                             | The Azure Devops account URL. ex: https://dev.azure.com/accountName     | ``                                      |
| `azp.token`                           | The Azure Devops access token.                                          | ``                                      |
| `azp.pool`                            | The name of the pipeline pool.                                          | kubernetes-azp-agents                   |
| `azp.agentName`                       | The name of the agent.                                                  | $(POD_NAME)                             |
| `azp.image.repository`                | The Docker Hub repository of the agent.                                 | microsoft/vsts-agent                    |
| `azp.image.tag`                       | The image tag of the agent.                                             | ubuntu-16.04-docker-18.06.1-ce-standard |
| `azp.image.pullPolicy`                | The image pull policy of the agent.                                     | IfNotPresent                            |
| `azp.resources.requests.cpu`          | The CPU requests of the agent.                                          | 0.5                                     |
| `azp.resources.requests.memory`       | The memory requests of the agent.                                       | 2Gi                                     |
| `azp.resources.limits.cpu`            | The CPU limits of the agent.                                            | 1                                       |
| `azp.resources.limits.memory`         | The memory limits of the agent.                                         | 8Gi                                     |
| `azp.persistence.enabled`             | Whether to create a PersistentVolume for the workspace.                 | `true`                                  |
| `azp.persistence.name`                | The name of the volume for the workspace.                               | workspace                               |
| `azp.persistence.labels`              | Labels to add to the PersistentVolume for the workspace.                | `{}`                                    |
| `azp.persistence.accessModes`         | Access modes for the PersistentVolume for the workspace.                | `[ "ReadWriteOnce" ]`                   |
| `azp.persistence.selector`            | The label selector for the PVC for the workspace.                       | `{}`                                    |
| `azp.persistence.storageClassName`    | The storage class of the PersistentVolume for the workspace.            | default                                 |
| `azp.persistence.storage`             | The requested capacity of the PersistentVolume for the workspace.       | `50Gi`                                  |
| `azp.persistence.storageLimit`        | The capacity limit of the PersistentVolume for the workspace.           | `null`                                  |
| `azp.lifecycle`                       | Lifecycle (postStart, preStop) for the agent.                           | `{}`                                    |
| `azp.extraEnv`                        | Extra environment variables to add to the agent.                        | `[]`                                    |
| `azp.extraVolumeMounts`               | Extra volume mounts to add to the agent.                                | `[]`                                    |
| `docker.enabled`                      | If the Docker sidecar should be enabled.                                | `true`                                  |
| `docker.image.repository`             | The Docker Hub repository of Docker.                                    | docker                                  |
| `docker.image.tag`                    | The image tag of Docker.                                                | 18.06.3-dind                            |
| `docker.image.pullPolicy`             | The image pull policy of Docker.                                        | IfNotPresent                            |
| `docker.resources.requests.cpu`       | The CPU requests of Docker.                                             | 0.5                                     |
| `docker.resources.requests.memory`    | The memory requests of Docker.                                          | 2Gi                                     |
| `docker.resources.limits.cpu`         | The CPU limits of Docker.                                               | 2                                       |
| `docker.resources.limits.memory`      | The memory limits of Docker.                                            | 16Gi                                    |
| `docker.persistence.enabled`          | Whether to create a PersistentVolume for Docker.                        | `true`                                  |
| `docker.persistence.name`             | The name of the volume for Docker.                                      | workspace                               |
| `docker.persistence.labels`           | Labels to add to the PersistentVolume for Docker.                       | `{}`                                    |
| `docker.persistence.accessModes`      | Access modes for the PersistentVolume for Docker.                       | `[ "ReadWriteOnce" ]`                   |
| `docker.persistence.selector`         | The label selector for the PVC for Docker.                              | `{}`                                    |
| `docker.persistence.storageClassName` | The storage class of the PersistentVolume for Docker.                   | default                                 |
| `docker.persistence.storage`          | The requested capacity of the PersistentVolume for Docker.              | `50Gi`                                  |
| `docker.persistence.storageLimit`     | The capacity limit of the PersistentVolume for Docker.                  | `null`                                  |
| `docker.lifecycle`                    | Lifecycle (postStart, preStop) for Docker.                              | `{}`                                    |
| `docker.extraEnv`                     | Extra environment variables to add to Docker.                           | `[]`                                    |
| `docker.extraVolumeMounts`            | Extra volume mounts to add to Docker.                                   | `[]`                                    |
| `nameOverride`                        | An override value for the name.                                         | ``                                      |
| `fullnameOverride`                    | An override value for the full name.                                    | ``                                      |
| `podManagementPolicy`                 | The order that pods are created (`OrderedReady` or `Parallel`).         | OrderedReady                            |
| `revisionHistoryLimit`                | Number of StatefulSet versions to keep.                                 | 25                                      |
| `updateStrategy.type`                 | The StatefulSet Update Strategy type.                                   | RollingUpdate                           |
| `updateStrategy.rollingUpdate`        | The StatefulSet RollingUpdate update strategy values.                   | `{ partition: 0 }`                      |
| `imagePullSecrets`                    | Image Pull Secrets to use.                                              | `[]`                                    |
| `labels`                              | Labels to add to the StatefulSet.                                       | `{}`                                    |
| `annotations`                         | Annotations to add to the StatefulSet.                                  | `{}`                                    |
| `podLabels`                           | Labels to add to the Pods.                                              | `{}`                                    |
| `podAnnotations`                      | Annotations to add to the Pods.                                         | `{}`                                    |
| `pdb.enabled`                         | Whether to enable a PodDisruptionBudget.                                | `true`                                  |
| `pdb.minAvailable`                    | The minimum number of pods to keep. Incompatible with `maxUnavailable`. | 50%                                     |
| `pdb.maxUnavailable`                  | The maximum unvailable pods. Incompatible with `minAvailable`.          | 50%                                     |
| `extraVolumes`                        | Extra volumes to add to the Pod.                                        | `[]`                                    |
| `extraVolumeClaimTemplates`           | Extra volumes claim templates to add to the StatefulSet.                | `[]`                                    |
| `dnsPolicy`                           | The pod DNS policy.                                                     | `null`                                  |
| `dnsConfig`                           | The pod DNS config.                                                     | `{}`                                    |
| `restartPolicy`                       | The pod restart policy.                                                 | Always                                  |
| `nodeSelector`                        | The pod node selector.                                                  | `{}`                                    |
| `tolerations`                         | The pod node tolerations.                                               | `{}`                                    |
| `affinity`                            | The pod node affinity.                                                  | `{}`                                    |
| `securityContext`                     | The pod security context.                                               | `{}`                                    |
| `hostNetwork`                         | Whether to use the host network of the node.                            | `false`                                 |
| `initContainers`                      | Init containers to add.                                                 | `[]`                                    |
| `sidecars`                            | Additional containers to add.                                           | `[]`                                    |
