gpfs
====

Install and configure gpfs

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

Joins the gpfs cluster, as defined in the pillar, if it is already joined, then it will get ignored.

``gpfs.tuning``
---------------

Updates the sysctl config, for best practice tuning, to reserve some memory for Spectrum Scale
