{{/*
Common labels.
*/}}
{{- define "flyan-data.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ default .Chart.AppVersion .Values.flyanData.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Image reference resolved to {{ repository }}:{{ tag-or-appVersion }}.
*/}}
{{- define "flyan-data.image" -}}
{{ .Values.flyanData.image.repository }}:{{ default .Chart.AppVersion .Values.flyanData.image.tag }}
{{- end }}


{{/*
Full env block shared by every workload. Renders a flat list of env
entries (literal values from .env plus secretKeyRef-or-value entries
for each secret). The caller is responsible for indenting the whole
block to the parent's depth, like:

  env:
    {{- include "flyan-data.env" . | nindent 4 }}

Internally we *do not* indent — the include returns lines starting at
column 0 so `nindent` at the call site produces uniform indentation.
*/}}
{{- define "flyan-data.env" -}}
{{- range $key, $value := .Values.flyanData.env }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- $secrets := list
    (dict "name" "DATABASE_URL"      "spec" .Values.flyanData.secrets.DATABASE_URL)
    (dict "name" "REDIS_URL"         "spec" .Values.flyanData.secrets.REDIS_URL)
    (dict "name" "DJANGO_SECRET_KEY" "spec" .Values.flyanData.secrets.DJANGO_SECRET_KEY)
}}
{{- range $s := $secrets }}
- name: {{ $s.name }}
{{- if and $s.spec.secretName $s.spec.secretKey }}
  valueFrom:
    secretKeyRef:
      name: {{ $s.spec.secretName }}
      key: {{ $s.spec.secretKey }}
{{- else }}
  value: {{ $s.spec.value | quote }}
{{- end }}
{{- end }}
{{- end }}
