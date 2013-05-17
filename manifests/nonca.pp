class pe_httpd::nonca (
  $proxy_ca_server    = undef,
  $proxy_ca_port      = '8140',
  $masterport         = '8140',
  $manage_puppet_conf = true,
  $certname           = $pe_httpd::certname,
) inherits pe_httpd {
  $is_ca = false

  validate_bool($manage_puppet_conf)

  if $proxy_ca_server {
    validate_string($proxy_ca_server)
    if $::osfamily == 'Debian' {
      exec { 'a2enmod proxy':
        path    => '/usr/bin:/opt/puppet/sbin',
        creates => [
          '/etc/puppetlabs/httpd/mods-enabled/proxy.load',
          '/etc/puppetlabs/httpd/mods-enabled/proxy.conf',
        ],
        notify  => Service['pe-httpd'],
      }
      exec { 'a2enmod proxy_http':
        path    => '/usr/bin:/opt/puppet/sbin',
        creates => '/etc/puppetlabs/httpd/mods-enabled/proxy_http.load',
        notify  => Service['pe-httpd'],
      }
    }
  }

  if $manage_puppet_conf {
    ini_setting { 'puppet.conf master ca' :
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'ca',
      value   => 'false',
    }
  }

  # Template uses: @certname, @proxy_ca_server, @osfamily, @masterport, @is_ca, @proxy_ca_port
  file { '/etc/puppetlabs/httpd/conf.d/puppetmaster.conf':
    ensure  => file,
    content => template("${module_name}/puppetmaster.conf.erb"),
    notify  => Service['pe-httpd'],
  }

  # Write this so settings::ca_server will work with
  # the agent -t on the local master's agent
  ## I want the PMs to use the DG as ca_server via $server
  #ini_setting { 'puppet.conf agent ca_server' :
  #  path    => '/etc/puppetlabs/puppet/puppet.conf',
  #  section => 'agent',
  #  setting => 'ca_server',
  #  value   => $ca_server,
  #}
}
