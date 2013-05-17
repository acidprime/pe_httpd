class pe_httpd::service {
  if ! defined(Service['pe-httpd']) {
    service { 'pe-httpd':
      ensure => running,
    }
  }
}
