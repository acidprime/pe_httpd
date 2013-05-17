class pe_httpd::ca (
  $certname           = $pe_httpd::certname,
  $master_certnames   = $pe_httpd::certname,
  $masterport         = '8140',
  $manage_puppet_conf = true,
  $manage_auth_conf   = true,
) inherits pe_httpd {
  $is_ca = true

  validate_bool($manage_puppet_conf, $manage_auth_conf)

  #split this stuff into pe_auth module
  if $manage_auth_conf {
    class { 'auth_conf::defaults':
      master_certname => $master_certnames,
    }
    # For CA
    auth_conf::acl { '/certificate_revocation_list':
      auth       => 'any',
      acl_method => 'find',
      allow      => '*',
      order      => 085,
    }
    # For Console
    auth_conf::acl { '/certificate_status':
      auth       => 'yes',
      acl_method => ['find','search', 'save', 'destroy'],
      allow      => 'pe-internal-dashboard',
      order      => 085,
    }
  }

  if $manage_puppet_conf {
    ini_setting { 'puppet.conf master ca' :
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'ca',
      value   => 'true',
    }

    ## I want the console to use the DG as ca_server via $server
    #ini_setting { 'puppet.conf agent ca_server' :
    #  path    => '/etc/puppetlabs/puppet/puppet.conf',
    #  section => 'agent',
    #  setting => 'ca_server',
    #  value   => $::clientcert,
    #}
  }

  # Template uses: @certname, @proxy_ca_server, @osfamily, @masterport, @is_ca, @proxy_ca_port
  file { '/etc/puppetlabs/httpd/conf.d/puppetmaster.conf':
    ensure  => file,
    content => template("${module_name}/puppetmaster.conf.erb"),
    notify  => Service['pe-httpd'],
  }
}
