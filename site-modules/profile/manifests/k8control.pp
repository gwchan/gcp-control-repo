class profile::k8control {
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  file { '/var/lib/etcd':
    ensure  => directory,
    mode    => '0600',
    recurse => true,
  }

  class {'kubernetes':
    controller => true,
  }
}
