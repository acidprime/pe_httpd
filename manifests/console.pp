class pe_httpd::console (
  $masterport = '8140',
) {
  # Port for inventory service
  ini_setting { 'puppet.conf master masterport' :
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'masterport',
    value   => $masterport,
  }
}
