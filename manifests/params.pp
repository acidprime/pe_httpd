class pe_httpd::params {
  $puppetmaster_conf   = '/etc/puppetlabs/httpd/conf.d/puppetmaster.conf'
  $certname            = $::clientcert
  $ca_server           = $settings::ca_server
  $puppet_service_name = 'pe-httpd'
}
