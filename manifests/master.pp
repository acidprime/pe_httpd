class pe_caproxy::master(
  $ca_server         = $pe_caproxy::params::ca_server,
  $cert_name         = $pe_caproxy::params::certname,
  $puppetmaster_conf = $pe_caproxy::params::puppetmaster_conf,
) inherits pe_caproxy::params {

  # Template uses: @cert_name , @ca_server
  file { $puppetmaster_conf:
    ensure  => file,
    content => template("${module_name}/puppetmaster.conf.erb"),
  }
  augeas{'puppet.conf ca' :
    context       => '/files//puppet.conf/master',
    changes       => "set ca false",
  }
  # Write this so settings::ca_server will work with
  # the agent -t on the local master's agent
  augeas{'puppet.conf ca_server' :
    context       => '/files//puppet.conf/agent',
    changes       => "set ca_server ${ca_server}",
  }
}
