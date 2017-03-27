# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "gpfs/map.jinja" import gpfs with context %}

include:
  - gpfs
{% if pillar['ofed'] is defined and "nicips.ib0" in pillar['xcat']['node'].iteritems() %}
  - network
{% endif %}

gpfs.cluster:
  gpfs.joined:
    - cluster: {{ gpfs.clustername }}
{% if gpfs.servers[0] == grains['host'] %}
    - master: {{ gpfs.servers[1] }}
{% else %}
    - master: {{ gpfs.servers[0] }}
{% endif %}
    - runas: root
    - require:
      - pkg: gpfs
      - gpfsgplbin
{% if pillar['ofed'] is defined and "nicips.ib0" in pillar['xcat']['node'].iteritems() %}
      - network: ib0.device
{% endif %}
    - require_in:
      - service: gpfs

gpfs.start:
  gpfs.started:
    - require:
      - gpfs: gpfs.cluster

mmmount_all:
  cmd.run:
    - name: sleep 30 ; mmmount all
    - require:
      - gpfs: gpfs.cluster
      - gpfs: gpfs.start
      - service: gpfs
