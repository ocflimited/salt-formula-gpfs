# -*- coding: utf-8 -*-
# vim: ft=sls

gpfs.repo:
  pkgrepo.managed:
    - name: gpfs
    - humanname: GPFS RPMs
    - baseurl: http://{{ salt['dnsutil.A'](gpfs.repo.server + '.' + grains['domain'])[0] }}{{ gpfs.repo.path }}
    - gpgcheck: 0
    - disabled: 1

gpfspkgs:
  pkg.installed:
    - pkgs:
      - gpfs.base
      - gpfs.ext
      - gpfs.gskit
      - gpfs.docs
      - gpfs.gpl
      - gpfs.msg.en_US
    - fromrepo: gpfs
    - refresh: True
    - require:
      - pkgrepo: gpfs.repo
      - pkg: gpfs-dep-pkg

gpfsgplbin-pkg:
  pkg.installed:
    - name: gpfs.gplbin-{{ grains['kernelrelease'] + '.' + grains['osarch'] }}
    - fromrepo: gpfs
    - refresh: True
    - require:
      - pkgrepo: gpfs.repo
      - pkg: gpfs-dep-pkg
      - pkg: gpfspkgs

gpfs-dep-pkg:
  pkg.latest:
    - pkgs:
      - ksh
      - m4
      - net-tools

gpfs.service:
  file.managed:
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
{%- if pillar['ofed']['enabled'] %}
      - service: openibd
{%- endif %}

gpfs.profile.sh:
  file.managed:
    - name: /etc/profile.d/gpfs.sh
    - source: salt://gpfs/files/gpfs.sh
    - mode: 555

gpfs.profile.csh:
  file.managed:
    - name: /etc/profile.d/gpfs.csh
    - source: salt://gpfs/files/gpfs.csh
    - mode: 555
