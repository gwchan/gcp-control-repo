class profile::example {
  $debian_nodes_query = 'nodes[certname]{facts{name = "operatingsystem" and value = "CentOS"}}'
  $debian_nodes = puppetdb_query($debian_nodes_query).map |$value| { $value["certname"] }
  notify {"Debian nodes":
    message => "Your debian nodes are ${join($debian_nodes, ', ')}",
  }
  file { '/tmp/display.html':
    ensure => file,
    content => epp('templates/display.epp', {'nodes_result' => $debian_nodes}),
  }
}
