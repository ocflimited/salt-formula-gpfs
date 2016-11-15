{%- if pillar['config']['gpfs']['enabled'] %}

include:
  - service.gpfs.package
  - service.gpfs.service
  - service.gpfs.tuning
  - service.gpfs.config

{%- endif %}
