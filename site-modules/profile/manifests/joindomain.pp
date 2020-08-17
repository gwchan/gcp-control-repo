class profile::joindomain {
  dsc_xdnsserveraddress {'DCDNS':
    dsc_address        => '192.168.0.15',
    dsc_interfacealias => 'Ethernet',
    dsc_addressfamily  => 'IPv4',
  }
  dsc_xcomputer {'puppet':
    dsc_name       => $facts['hostname'],
    dsc_domainname => 'puppet',
    dsc_credential => {
      user     => 'PUPPET\administrator',
      password => 'puppetlabs1!'
    },
    require => Dsc_xdnsserveraddress['DCDNS'],
  }
  reboot {'domainjoin-reboot':
    subscribe => Dsc_xcomputer['puppet'],
  }
}
