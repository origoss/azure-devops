{{- define "appdemo.labels" -}}
{{- if $.Values.appdemo.labels }}
{{ toYaml $.Values.appdemo.labels }}
{{- end }}
{{- end -}}

{{- define "appdemo.image" -}} 
{{- if $.Values.appdemo.image -}}
{{ default "" $.Values.appdemo.image.prefix }}{{ default "aspnetcoredemoapp" $.Values.appdemo.image.name }}:{{ default "latest" $.Values.appdemo.image.tag }}
{{- else -}}
aspnetcoredemoapp:latest
{{- end -}}
{{- end -}}

{{- define "appdemo.service.name" -}} 
{{- if $.Values.appdemo.service.name -}}
{{ $.Values.appdemo.service.name }}
{{- else -}}
{{ $.Values.appdemo.name }}
{{- end -}}
{{- end -}}

{{- define "appdemo.route.name" -}} 
{{- if $.Values.appdemo.route.name -}}
{{ $.Values.appdemo.route.name }}
{{- else -}}
{{ $.Values.appdemo.name }}
{{- end -}}
{{- end -}}
