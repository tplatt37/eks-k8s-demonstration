{{/*
Additional labels to be placed on the main Deployment.
*/}}
{{- define "a-new-startup.labels" -}}
arbitrary-key: arbitrary-value
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}