# @summary Installs the folding@home client
#
#
# @param gpu_enable Indicates if the GPU should be enabled
# @param user_name Specify your folding@home stats username
# @param allow Specify IPs that can access the web control client remotely
# @param web_allow Specify IPs that can access the web control client remotely
# @param tean_id Team ID that your contributing to
# @param url Download URL for the Folding@Home Client Installer
# @param [Hash] cpu_slots Hash representing the CPU slots and the number of cores for each slot
# @param web_password Password for remote access to the web console
# @param user_passkey Passkey for yor username, if you have one
# @param service_ensure Defaults to 'running'. Useful for automated tests.
#
# @example
#   include foldingathome
#
class foldingathome (
  $gpu_enable = false,
  $user_name = undef,
  $allow = undef,
  $web_allow = undef,
  $team_id = 0,
  $url = 'http://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.5/fahclient_7.5.1_amd64.deb',
  Hash $cpu_slots = {'0' => '1'},
  $web_password = undef,
  $user_passkey = undef,
  $service_ensure = 'running',
) {
  ensure_resource('package', 'bzip2', {'ensure' => 'installed'})

  archive {'/tmp/fahclient.deb':
    ensure => present,
    source => $url
  }

  package {'fahclient':
    ensure   => installed,
    provider => 'dpkg',
    source   => '/tmp/fahclient.deb',
    require  => [Archive['/tmp/fahclient.deb'], File['/etc/fahclient/config.xml'], Package['bzip2']],
  }

  service {'FAHClient':
    ensure  => $service_ensure,
    require => [Package['fahclient'], File['/etc/fahclient/config.xml']]
  }

  file {'/etc/fahclient':
    ensure => directory,
  }

  file {'/etc/fahclient/config.xml':
    ensure  => file,
    content => epp('foldingathome/config.xml.epp'),
    require => File['/etc/fahclient'],
    notify  => Service['FAHClient']
  }
}
