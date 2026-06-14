{{/*
Common labels.
*/}}
{{- define "odyssey.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Image references. Each container picks one of:
  {{ include "odyssey.apiImage" . }}
  {{ include "odyssey.webImage" . }}
*/}}
{{- define "odyssey.apiImage" -}}
{{ .Values.odyssey.image.api.repository }}:{{ default .Chart.AppVersion .Values.odyssey.image.api.tag }}
{{- end }}

{{- define "odyssey.webImage" -}}
{{ .Values.odyssey.image.web.repository }}:{{ default .Chart.AppVersion .Values.odyssey.image.web.tag }}
{{- end }}


{{/*
Shared env block. Renders the static .env map plus secretKeyRef/value
entries for each secret. Caller indents with `nindent N`.

Secrets iterate over .Values.odyssey.secrets — any key with both
secretName + secretKey resolves via secretKeyRef; any key with only
a value resolves to a literal. Keys with neither are skipped so the
ANTHROPIC-style "optional in dev, required in prod" pattern works
without a chart change every time.
*/}}
{{- define "odyssey.env" -}}
{{- range $key, $value := .Values.odyssey.env }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- range $name, $spec := .Values.odyssey.secrets }}
{{- if and $spec.secretName $spec.secretKey }}
- name: {{ $name }}
  valueFrom:
    secretKeyRef:
      name: {{ $spec.secretName }}
      key: {{ $spec.secretKey }}
{{- else if $spec.value }}
- name: {{ $name }}
  value: {{ $spec.value | quote }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Image-pull-secrets stanza.
*/}}
{{- define "odyssey.pullSecrets" -}}
{{- with .Values.odyssey.image.pullSecrets }}
imagePullSecrets:
  {{- range . }}
  - name: {{ . }}
  {{- end }}
{{- end }}
{{- end }}
