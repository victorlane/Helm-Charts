{{/*
Common labels.
*/}}
{{- define "hermes.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ default .Chart.AppVersion .Values.hermes.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Image reference resolved to {{ repository }}:{{ tag-or-appVersion }}.
*/}}
{{- define "hermes.image" -}}
{{ .Values.hermes.image.repository }}:{{ default .Chart.AppVersion .Values.hermes.image.tag }}
{{- end }}


{{/*
Full env block shared by every workload. Renders a flat list of env
entries (literal values from .env plus secretKeyRef-or-value entries
for each secret). The caller is responsible for indenting the whole
block to the parent's depth, like:

  env:
    {{- include "hermes.env" . | nindent 4 }}

Internally we *do not* indent — the include returns lines starting at
column 0 so `nindent` at the call site produces uniform indentation.
*/}}
{{- define "hermes.env" -}}
{{- range $key, $value := .Values.hermes.env }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- $secrets := list
    (dict "name" "DATABASE_URL"      "spec" .Values.hermes.secrets.DATABASE_URL)
    (dict "name" "REDIS_URL"         "spec" .Values.hermes.secrets.REDIS_URL)
    (dict "name" "DJANGO_SECRET_KEY" "spec" .Values.hermes.secrets.DJANGO_SECRET_KEY)
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
