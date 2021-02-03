node 'node01' {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    onlyif  => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
  }

  package { 'node01-vim':
    ensure  => 'installed',
    name    => 'vim',
    require => Exec['apt-get update'],
  }
}
