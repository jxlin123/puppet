class ocf::packages::cups {

  # install cups
  package { [ 'cups', 'cups-bsd' ]: }

  file {
    # set print server destination
    '/etc/cups/client.conf':
      content => "ServerName printhost\nEncryption Always\n",
      require => Package[ 'cups', 'cups-bsd' ];
    # set default printer double
    '/etc/cups/lpoptions':
      content => 'Default double',
      require => Package[ 'cups', 'cups-bsd' ];
    # set default paper size
    '/etc/papersize':
      content => 'letter';
    '/etc/cups/ppd/single.ppd':
      # content => epp('ocf/cups/raster.ppd.epp', { 'double' => false }),
      # group   => 'lp',
      ensure  => absent,
      require => Package['cups', 'cups-bsd'],
      notify  => Service['cups'];
    '/etc/cups/ppd/double.ppd':
      # content => epp('ocf/cups/raster.ppd.epp', { 'double' => true }),
      # group   => 'lp',
      ensure  => absent,
      require => Package['cups', 'cups-bsd'],
      notify  => Service['cups']
  }

  service { 'cups':
    subscribe => File['/etc/cups/client.conf', '/etc/cups/lpoptions'],
    require   => Package[ 'cups', 'cups-bsd' ];
  }

}
