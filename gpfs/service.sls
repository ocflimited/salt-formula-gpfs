# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "gpfs/map.jinja" import gpfs with context %}

gpfs.service:
  file.managed
    - name: /etc/init.d/gpfs
    - source: salt://gpfs/files/gpfs
    - follow_symlinks: False
    - user: root
    - group: root
    - mode: 555
    - require_in:
      - service: gpfs
  service.running:
    - name: gpfs
    - enable: True
    - require:
      - pkg: gpfspkgs
      - file: gpfs.service
{%- if pillar['config']['ofed']['enabled'] %}
      - service: openibd
{%- endif %}
