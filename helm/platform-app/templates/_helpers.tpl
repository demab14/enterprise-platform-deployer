{{/*
Full name of the release
*/}}
{{- define "platform-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-app.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
client: {{ .Values.client.name | quote }}
environment: {{ .Values.client.environment | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-app.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Service account name
*/}}
{{- define "platform-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- include "platform-app.fullname" . }}
{{- else }}
default
{{- end }}
{{- end }}
