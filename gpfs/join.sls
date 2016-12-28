# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "gpfs/map.jinja" import gpfs with context %}

include:
  - gpfs

gpfs.cluster:
  gpfs.joined:
    - cluster: {{ gpfs.clustername }}
{% if gpfs.servers[0] == grains['host'] %}
    - master: {{ gpfs.servers[1] }}
{% else %}
    - master: {{ gpfs.servers[0] }}
{% endif %}
    - require:
      - pkg: gpfs
    - require_in:
      - service: gpfs
