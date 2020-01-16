class profile::winbase {

  #the base profile should include component modules that will be on all windows nodes
  user {'test1':
    ensure => present,
    password => 'P@ssw0rd123',
  }
}
