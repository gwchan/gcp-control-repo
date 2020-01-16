class profile::winbase {

  #the base profile should include component modules that will be on all windows nodes
  dsc_user {'Test1':
    dsc_ensure => present,
    dsc_disabled => false,
  }
}
