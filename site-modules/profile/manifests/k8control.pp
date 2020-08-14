class profile::k8control {
  class { 'docker':
    version => '17.03.1.ce-1.el7.centos',
  }
  
  class {'kubernetes':
    controller => true,
  }
}
