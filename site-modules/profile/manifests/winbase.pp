class profile::winbase {
  Integer $application_log_max_size = 1024000000,
  Integer $security_log_max_size = 512000000,
  Integer $system_log_max_size = 512000000,
}{
  #the base profile should include component modules that will be on all windows nodes
  user { 'Administrator':
    ensure  => 'present',
    comment => 'Built-in account for administering the computer/domain',
    groups  => ['Administrators'],
  }
#Test
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

#Set Maximum Event Logs Size

  registry_value { 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\EventLog\\Application\\MaxSize':
    ensure => present,
    type   => 'dword',
    data   => $application_log_max_size
  }

  registry_value { 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\EventLog\\Security\\MaxSize':
    ensure => present,
    type   => 'dword',
    data   => $security_log_max_size
  }

  registry_value { 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\EventLog\\System\\MaxSize':
    ensure => present,
    type   => 'dword',
    data   => $system_log_max_size
  }

#Set Retention for Event Logs
  registry_value { 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\EventLog\\Application\\Retention':
    ensure => present,
    type   => 'dword',
    data   => '0'
  }

  registry_value { 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\EventLog\\Security\\Retention':
    ensure => present,
    type   => 'dword',
    data   => '0'
  }

  registry_value { 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Services\\EventLog\\System\\Retention':
    ensure => present,
    type   => 'dword',
    data   => '0'
  }
}
