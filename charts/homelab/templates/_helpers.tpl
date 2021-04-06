{{- define "homelab.qbittorrent.port" -}}
8080
{{- end -}}
{{- define "homelab.radarr.port" -}}
7878
{{- end -}}
{{- define "homelab.sonarr.port" -}}
8989
{{- end -}}
{{- define "homelab.jackett.port" -}}
9117
{{- end -}}
{{- define "homelab.plex.port" -}}
32400
{{- end -}}
{{- define "homelab.oauth2Proxy.port" -}}
4180
{{- end -}}

{{- define "homelab.qbittorrent.configSize" -}}
100Mi
{{- end -}}
{{- define "homelab.radarr.configSize" -}}
100Mi
{{- end -}}
{{- define "homelab.sonarr.configSize" -}}
100Mi
{{- end -}}
{{- define "homelab.jackett.configSize" -}}
100Mi
{{- end -}}
{{- define "homelab.plex.configSize" -}}
2Gi
{{- end -}}



{{/*
Expand the name of the chart.
*/}}

{{/* Generate port list for apps */}}
#{{- range $key, $value := .Values.apps }}
#{{- end}}


{{- define "homelab.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "homelab.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "homelab.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "homelab.labels" -}}
helm.sh/chart: {{ include "homelab.chart" . }}
{{ include "homelab.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "homelab.selectorLabels" -}}
app.kubernetes.io/name: {{ include "homelab.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "homelab.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "homelab.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
