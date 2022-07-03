{{- define "helpers.configmaps.renderConfigMap" -}}
{{- $v := dict -}}
{{- if typeIs "string" .value -}}
{{- $v = fromYaml .value -}}
{{- else if kindIs "map" .value -}}
{{- $v = .value -}}
{{- end -}}
{{- range $key, $value := $v }}
{{- if eq (typeOf $value) "float64" }}
{{ printf "%s: %s" $key (toString $value | quote) }}
{{- else if empty $value }}
{{- if eq (typeOf $value) "bool" }}
{{ printf "%s: \"false\"" $key }}
{{- else }}
{{ printf "%s: %s" $key ("" | quote) }}
{{- end -}}
{{- else if kindIs "string" $value }}
{{- if or (eq $value "False") (eq $value "True") (eq $value "false") (eq $value "true")}}
{{ printf "%s: %s" $key (quote $value) }}
{{- else }}
{{ printf "%s: %s" $key $value }}
{{- end -}}
{{- else }}
{{ $key }}: {{$value | toJson | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.configmaps.includeEnv" -}}
{{- $ctx := .context -}}
{{- $s := dict -}}
{{- if typeIs "string" .value -}}
{{- $s = fromYaml .value -}}
{{- else if kindIs "map" .value -}}
{{- $s = .value -}}
{{- end -}}
{{- range $sName, $envKeys := $s -}}
{{- range $i, $envKey := $envKeys }}
{{- if kindIs "string" $envKey }}
- name: {{ $envKey }}
  valueFrom:
    configMapKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $envKey }}
{{- else if kindIs "map" $envKey -}}
{{- range $keyName, $key := $envKey }}
- name: {{ $keyName }}
  valueFrom:
    configMapKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.configmaps.includeEnvConfigmap" -}}
{{- $ctx := .context -}}
{{- range $i, $sName := .value }}
- configMapRef:
    name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
{{- end -}}
{{- end -}}
