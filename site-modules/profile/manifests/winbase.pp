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

#Purge Un-Managed Users
  resources { 'user':
    purge => true,
    unless_system_user => true,
  }

#Manage ACL of System Files
  acl { 'c:/Temp':
  #  purge       => true,
    permissions => [
    { identity => 'Administrators', rights => ['full'] },
    { identity => 'Creator Owner', rights => ['full'] },
    { identity => 'ALL APPLICATION PACKAGES', rights => ['read','execute'] },
    { identity => 'ALL RESTRICTED APPLICATION PACKAGES', rights => ['read','execute'] },
    { identity => 'Authenticated Users', rights => ['read','execute'] },
    { identity => 'System', rights => ['full'] }
    ],
    inherit_parent_permissions => false,
  }

#Set Logon Message
  registry_value { 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\\legalnoticecaption':
    ensure => present,
    type   => string,
    data   => 'Notice: Unauthorized access is strictly prohibited! All access will be logged and monitored'
  }

  registry_value { 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System\\legalnoticetext':
    ensure => present,
    type   => string,
    data   => 'Notice: Unauthorized access is strictly prohibited! All access will be logged and monitored'
  }
}
