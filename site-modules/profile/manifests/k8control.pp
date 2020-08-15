class profile::k8control {
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  class {'kubernetes':
    controller => true,
  }
}
