class pe_httpd::nonconsole (
  $inventory_server,
  $inventory_port = '8140',
) {
  ini_setting { 'puppet.conf master inventory_server' :
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'inventory_server',
    value   => $inventory_server,
  }
  ini_setting { 'puppet.conf master inventory_port' :
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'inventory_port',
    value   => $inventory_port,
  }
}
