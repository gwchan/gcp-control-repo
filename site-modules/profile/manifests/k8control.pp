class profile::k8control (
  class {'kubernetes':
    controller => true,
  }
}
