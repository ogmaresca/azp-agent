{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "azp-agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "azp-agent.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "azp-agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the pod security policy to use
*/}}
{{- define "azp-agent.psp.name" -}}
{{- default .Values.rbac.psp.name (printf "%s-%s" .Release.Namespace (include "azp-agent.fullname" .)) | trunc 63 -}}
{{- end -}}

{{/*
Create the name of the pod security policy role(binding) to use
*/}}
{{- define "azp-agent.psp.rbacname" -}}
{{- printf "%s-psp" (include "azp-agent.fullname" . | trunc 59) -}}
{{- end -}}

{{/*
Create the name of the autoscaler service account to use
*/}}
{{- define "azp-agent.serviceAccountName" -}}
{{ .Values.serviceAccount.create | ternary (include "azp-agent.fullname" .) (.Values.serviceAccount.name | default "default") | trunc 63 }}
{{- end -}}

{{/*
Name for the autoscaler
*/}}
{{- define "azp-agent.autoscaler.name" -}}
{{- printf "%s-autoscaler" (include "azp-agent.name" . | trunc 52) -}}
{{- end -}}

{{/*
Fully qualified name for the autoscaler
*/}}
{{- define "azp-agent.autoscaler.fullname" -}}
{{- printf "%s-autoscaler" (include "azp-agent.fullname" . | trunc 52) -}}
{{- end -}}

{{/*
Create the name of the pod security policy to use
*/}}
{{- define "azp-agent.autoscaler.psp.name" -}}
{{- default .Values.scaling.rbac.psp.name (printf "%s-%s" .Release.Namespace (include "azp-agent.autoscaler.fullname" .)) | trunc 63 -}}
{{- end -}}

{{/*
Create the name of the pod security policy role(binding) to use
*/}}
{{- define "azp-agent.autoscaler.psp.rbacname" -}}
{{- printf "%s-autoscaler-psp" (include "azp-agent.autoscaler.fullname" . | trunc 48) -}}
{{- end -}}

{{/*
Create the name of the autoscaler service account to use
*/}}
{{- define "azp-agent.autoscaler.serviceAccountName" -}}
{{ .Values.scaling.serviceAccount.create | ternary (include "azp-agent.autoscaler.fullname" .) (.Values.scaling.serviceAccount.name | default "default" | trunc 63) }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "azp-agent.selector" -}}
name: {{ include "azp-agent.fullname" . }}
release: {{ .Release.Name }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "azp-agent.labels" -}}
{{ include "azp-agent.selector" . }}
app: {{ include "azp-agent.fullname" . }}
chart: {{ include "azp-agent.chart" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "azp-agent.stringDict" -}}
{{ range $key, $value := . }}
{{ $key | quote }}: {{ $value | quote }}
{{ end }}
{{- end -}}

{{/* https://github.com/openstack/openstack-helm-infra/blob/master/helm-toolkit/templates/utils/_joinListWithComma.tpl */}}
{{- define "helm-toolkit.utils.joinListWithComma" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}},{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}
