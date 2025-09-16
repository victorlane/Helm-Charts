{{/* SUPERUSER secret */}}
{{- define "bugsink.superuser" -}}
{{- if and .Values.bugsink.secrets.SUPERUSER.secretName .Values.bugsink.secrets.SUPERUSER.secretKey -}}
secretRef
{{- else if .Values.bugsink.secrets.SUPERUSER.value -}}
{{ .Values.bugsink.secrets.SUPERUSER.value }}
{{- else -}}
admin:{{ randAlphaNum 16 }}
{{- end -}}
{{- end }}

{{/* SECRET_KEY */}}
{{- define "bugsink.secretKey" -}}
{{- if and .Values.bugsink.secrets.SECRET_KEY.secretName .Values.bugsink.secrets.SECRET_KEY.secretKey -}}
secretRef
{{- else if .Values.bugsink.secrets.SECRET_KEY.value -}}
{{ .Values.bugsink.secrets.SECRET_KEY.value }}
{{- else -}}
{{ randAlphaNum 64 }}
{{- end -}}
{{- end }}

{{/* DATABASE_URL */}}
{{- define "bugsink.databaseUrl" -}}
{{- if and .Values.bugsink.secrets.DATABASE_URL.secretName .Values.bugsink.secrets.DATABASE_URL.secretKey -}}
secretRef
{{- else if .Values.bugsink.secrets.DATABASE_URL.value -}}
{{ .Values.bugsink.secrets.DATABASE_URL.value }}
{{- else -}}
mysql://{{ .Values.bugsink.mariadb.username }}:{{ default (randAlphaNum 16) .Values.bugsink.mariadb.password }}@{{ .Release.Name }}-mariadb:3306/{{ .Values.bugsink.mariadb.database }}
{{- end -}}
{{- end }}
