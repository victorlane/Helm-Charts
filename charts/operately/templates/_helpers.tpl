{{- define "operately.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "operately.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "operately.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "operately.labels" -}}
app.kubernetes.io/name: {{ include "operately.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "operately.selectorLabels" -}}
app.kubernetes.io/name: {{ include "operately.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "operately.secretKeyBase" -}}
{{- if .Values.secrets.secretKeyBase -}}
{{- .Values.secrets.secretKeyBase -}}
{{- else -}}
{{- randAlphaNum 64 -}}
{{- end -}}
{{- end -}}

{{- define "operately.blobTokenSecretKey" -}}
{{- if .Values.secrets.blobTokenSecretKey -}}
{{- .Values.secrets.blobTokenSecretKey -}}
{{- else -}}
{{- randAlphaNum 32 | b64enc -}}
{{- end -}}
{{- end -}}

{{- define "operately.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{ .Values.postgresql.fullnameOverride }}
{{- else -}}
{{ printf "%s-postgresql" .Release.Name }}
{{- end -}}
{{- else -}}
{{- /* fall back unused when external DB */ -}}
{{ printf "%s-postgresql" .Release.Name }}
{{- end -}}
{{- end -}}

{{- define "operately.database.url" -}}
{{- $dbUrl := .Values.externalPostgresql.databaseUrl -}}
{{- if and .Values.externalPostgresql.enabled $dbUrl }}
{{- $dbUrl -}}
{{- else if and .Values.externalPostgresql.enabled (not $dbUrl) (not .Values.externalPostgresql.existingSecret) -}}
{{- $host := .Values.externalPostgresql.host -}}
{{- $port := .Values.externalPostgresql.port -}}
{{- $db := .Values.externalPostgresql.database -}}
{{- $user := .Values.externalPostgresql.username -}}
{{- printf "ecto://%s:%s@%s:%v/%s" $user .Values.externalPostgresql.password $host $port $db -}}
{{- else if and .Values.externalPostgresql.enabled .Values.externalPostgresql.existingSecret -}}
{{- /* When using existingSecret, we can't build the URL here - it will be built in the deployment */ -}}
{{- "FROM_SECRET" -}}
{{- else if .Values.postgresql.enabled -}}
{{- $host := include "operately.postgresql.host" . -}}
{{- $port := 5432 -}}
{{- $db := .Values.postgresql.auth.database -}}
{{- $user := .Values.postgresql.auth.username -}}
{{- $pass := .Values.postgresql.auth.password -}}
{{- printf "ecto://%s:%s@%s:%v/%s" $user $pass $host $port $db -}}
{{- else -}}
{{- /* No DB configured; leave empty to surface error */ -}}
{{- "" -}}
{{- end -}}
{{- end -}}
