class profile::k8control {
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  file { '/var/lib/etcd':
    ensure  => directory,
    mode    => '0600',
    recurse => true,
  }

  file { '/home/guangwei/.kube':
    ensure  => directory,
    mode    => '0600',
    recurse => true,
    owner   => 'guangwei',
    group   => 'guangwei',
  }

  class {'kubernetes':
    controller => true,
  }

  exec {'copykubeconfig':
    command => 'sudo cp -i /etc/kubernetes/admin.conf /home/guangwei/.kube/config',
    path    => '/usr/bin/'
    user    => 'guangwei',
    require => Class['kubernetes'],
  }

  file { '/home/guangwei/.kube/config':
    ensure  => present,
    mode    => '0600',
    owner   => 'guangwei',
    group   => 'guangwei',
    require => Exec['copykubeconfig'],
  }
}
