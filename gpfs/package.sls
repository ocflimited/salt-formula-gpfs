# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "gpfs/map.jinja" import gpfs with context %}

gpfs.repo:
  pkgrepo.managed:
    - name: gpfs
    - humanname: GPFS RPMs
    - baseurl: http://{{ gpfs.repo.server + '.' + grains['domain'])[0] }}{{ gpfs.repo.path }}
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
