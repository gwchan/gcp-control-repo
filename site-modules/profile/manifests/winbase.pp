class profile::winbase {

  #the base profile should include component modules that will be on all windows nodes
  user {'Guest':
    name => 'Guest',
    ensure => present,
    groups    => ['Guests'],
    managehome => true,
    comment => 'Built-in account for guest access to the computer/domain (Managed by Puppet)',
  }
}
