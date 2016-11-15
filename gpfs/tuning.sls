# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "gpfs/map.jinja" import gpfs with context %}

{% set mem_size=(((grains['mem_total'] * 1024) // 100) * 6) %}

vm.min_free_kbytes:
  sysctl.present:
{% if mem_size > gpfs.min_free_kbytes_max_value %}
    - value: {{ gpfs.min_free_kbytes_max_value }}
{% else %}
    - value: {{ mem_size }}
{% endif %}