class profile::winbase {

  #the base profile should include component modules that will be on all windows nodes
  user { 'Administrator':
    ensure  => 'present',
    comment => 'Built-in account for administering the computer/domain',
    groups  => ['BUILTIN\Administrators'],
  }

  user { 'DefaultAccount':
    ensure  => 'present',
    comment => 'A user account managed by the system.',
    groups  => ['BUILTIN\System Managed Group'],
  }
  
  user {'Guest':
    name => 'Guest',
    ensure => present,
    groups    => ['Guests'],
    comment => 'Built-in account for guest access to the computer/domain (Managed by Puppet)',
  }

  exec { 'Disable Guest Account':
    command     => 'net user Guest /active:no',
  }
}
