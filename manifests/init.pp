class pe_httpd {
  include pe_httpd::service

  $certname = $::clientcert ? {
    undef   => $settings::certname, # puppet apply
    default => $::clientcert,       # puppet agent
  }
}
