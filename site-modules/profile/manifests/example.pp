class profile::example (
  String $email_file = "/tmp/display.html",
) {
  $debian_nodes_query = 'nodes[certname] {
                          facts {
                            name = "operatingsystem" 
                            and value = "CentOS"
                          }
                        }'
  $debian_nodes = puppetdb_query($debian_nodes_query).map |$value| { $value["certname"] }
  notify {"Debian nodes":
    message => "Your debian nodes are ${join($debian_nodes, ', ')}",
  }
  file { $email_file :
    ensure => file,
    content => epp('profile/display.epp', {'nodes_result' => $debian_nodes}),
  }

  schedule { 'everyday': 
    period  => daily,
    range   => "2-4",
    repeat  => "1",
  }

  exec {'Send Email':
    command   => "sendmail -t < ${email_file}",
    path      => '/usr/sbin/',
    schedule  => 'everyday',
  }
}
