{{- define "static-site.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "static-site.fullname" -}}
{{ include "static-site.name" . }}-{{ .Release.Name }}
{{- end }}

{{- define "static-site.labels" -}}
app.kubernetes.io/name: {{ include "static-site.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
