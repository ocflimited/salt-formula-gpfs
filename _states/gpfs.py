# -*- coding: utf-8 -*-
'''
Manage GPFS Clusters
========================

Example:

.. code-block:: yaml

      gpfs.joined
        - cluster: gpfs.cluster
'''

# Import python libs
import logging
import os

# Import salt libs
import salt.utils

log = logging.getLogger(__name__)


def __virtual__():
    '''
    Only load if GPFS is installed.
    '''
    os.environ["PATH"] += os.pathsep + '/usr/lpp/mmfs/bin'
    return salt.utils.which('mmlscluster') is not None


def joined(cluster,
           master,
           runas=None,
           **kwargs):
    '''
    Ensure the current node is joined to the cluster

    cluster
        Name of the GPFS cluster
    master
        Name of the GPFS master to join from
    runas
        The user to run the GPFS command as
    '''

    result = __salt__['gpfs.cluster_member'](cluster, runas=runas)
    changes = {}
    ret = { 'name' : cluster }

    if result == False:
      res1 = __salt__['gpfs.cluster_configured'](runas=runas)
      if res1 == False:
        if __opts__['test']:
          ret['result'] = None
          ret['comment'] = "Would join gpfs cluster: " + cluster
        else:
          res2 = __salt__['gpfs.join_cluster'](master, runas=runas)
          if res2 == True:
            changes['old'] = 'no cluster member'
            changes['new'] = 'joined via: ' + master
            ret['result'] = True
            ret['comment'] = 'Joined GPFS cluster ' + cluster
          else:
            ret['result'] = False
            ret['comment'] = 'Could not join the cluster'
      else:
        ret['result'] = False
        ret['comment'] = 'Member of existing GPFS cluster'
    else:
      ret['result'] = True
      ret['comment'] = 'Already member of this GPFS cluster'

    ret['changes'] = changes

    return ret

def started(runas=None,
            **kwargs):

    '''
    Ensure the current node has started gpfs

    runas
        The user to run the GPFS command as
    '''

    result = __salt__['gpfs.cluster_started'](runas=runas)
    changes = {}
    ret = { 'name' : __grains__['host'] }

    if result == False:
      if __opts__['test']:
        ret['result'] = None
        ret['comment'] = "GPFS would be started"
      else:
        res1 = __salt__['gpfs.start_cluster'](runas=runas)
        if res1 == False:
          ret['result'] = False
          ret['comment'] = "There was an error start GPFS"
        else:
          changes['old'] = 'gpfs down'
          changes['new'] = 'gpfs started'
          ret['result'] = True
          ret['comment'] = 'GPFS was started'
    else:
      ret['result'] = True
      ret['comment'] = 'GPFS is already active'

    ret['changes'] = changes

    return ret
