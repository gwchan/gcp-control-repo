class profile::winbase {

  #the base profile should include component modules that will be on all windows nodes
  user { 'Administrator':
    ensure  => 'present',
    comment => 'Built-in account for administering the computer/domain',
    groups  => ['Administrators'],
  }

  user { 'DefaultAccount':
    ensure  => 'present',
    comment => 'A user account managed by the system.',
    groups  => ['System Managed Accounts Group'],
  }
  
  user {'Guest':
    name => 'Guest',
    ensure => present,
    groups    => ['Guests'],
    comment => 'Built-in account for guest access to the computer/domain (Managed by Puppet)',
  }

  user { 'admin':
    ensure => 'present',
    groups => ['Administrators'],
  }

  exec { 'Disable Guest Account':
    path => 'C:\\Windows\\System32',
    command => 'net.exe user Guest /active:no',
  }
}
