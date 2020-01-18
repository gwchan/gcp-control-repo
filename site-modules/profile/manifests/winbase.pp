class profile::winbase {

  #the base profile should include component modules that will be on all windows nodes
  user {'Guest':
    ensure => present,
  }
}
