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
*/}}
{{- define "odyssey.env" -}}
{{- range $key, $value := .Values.odyssey.env }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- $secrets := list
    (dict "name" "DATABASE_URL"    "spec" .Values.odyssey.secrets.DATABASE_URL)
    (dict "name" "ADMIN_PASSWORD"  "spec" .Values.odyssey.secrets.ADMIN_PASSWORD)
    (dict "name" "AUTH_SECRET"     "spec" .Values.odyssey.secrets.AUTH_SECRET)
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
