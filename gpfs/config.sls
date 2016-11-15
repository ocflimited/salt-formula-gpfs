# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "gpfs/map.jinja" import gpfs with context %}

gpfs.cluster:
  gpfs.joined:
    - cluster: {{ gpfs.clustername }}
{% if gpfs.servers[0] == grains['host'] %}
    - master: {{ gpfs.servers[1] }}
{% else %}
    - master: {{ gpfs.servers[0] }}
{% endif %}
    - require:
      - pkg: gpfspkgs
    - require_in:
      - service: gpfs.service

gpfs.profile.sh:
  file.managed
    - name: /etc/profile.d/gpfs.sh
    - source: salt://gpfs/files/gpfs.sh
    - mode: 555

gpfs.profile.csh:
  file.managed
    - name: /etc/profile.d/gpfs.csh
    - source: salt://gpfs/files/gpfs.csh
    - mode: 555