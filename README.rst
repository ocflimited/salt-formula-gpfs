gpfs
====

Install and configure Spectrum Scale (gpfs)

Available states
================

.. contents::
    :local:

``gpfs``
--------

Installs gpfs package, configures the service, and the environment

``gpfs.join``
-------------

Includes the ``gpfs`` state.

Joins the gpfs cluster, as defined in the pillar, if it is already joined, then it will get ignored. It will start gpfs, if it is down

``gpfs.tuning``
---------------

Updates the sysctl config, for best practice tuning, to reserve some memory for Spectrum Scale

Dependancies
============

This state is dependant on:

* ofed_

.. _ofed: https://gitlab.ocf.co.uk/salt/salt-formula-ofed

Example Pillar
==============

.. code-block::

  # -*- coding: utf-8 -*-
  # vim: ft=yaml
  
  gpfs:
  
    # The version type of GPFS to install on the system
    # This can be one of: express, standard or advanced
    version_type: standard
  
    # The GUI is disabled by default
    gui_enabled: False
  
    # The NSD servers to grab the gpfs from
    servers:
      - gpfs01
      - gpfs02
  
    # The GPFS cluster to join
    clustername: gpfs.cluster
  
    # The maximum value for vm.min_free_kbytes should be allowed
    # Anything more than this doesn't make sense
    min_free_kbytes_max_value: 15254502
  
    # Label this state to be enabled or disabled
    enabled: true
  
    # Build the portability layer.
    # If set to false, the configs will expect to have the rpm already available
    # If set to true, then the formula will compile the portability layer
    rebuild: false
  
    # The device that will be mounted and used
    devices:
      gpfs:
        name: gpfs
        mount: /gpfs
  
    # The repo to use for
    repo:
      server: xcat
      path: /install/post/otherpkgs/repos/gpfs