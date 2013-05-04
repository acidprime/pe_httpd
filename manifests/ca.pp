class pe_caproxy::ca {
  class { 'auth_conf::defaults':
    master_certname => $::fact_puppetmaster_certname,
  }
  augeas {'puppet.conf ca_server' :
    context       => '/files//puppet.conf/main',
    changes       => "set ca_server ${::clientcert}",
  }
  auth_conf::acl { '/certificate_revocation_list':
    auth       => 'any',
    acl_method => ['find'],
    allow      => '*',
    order      => 085,
  }
}
