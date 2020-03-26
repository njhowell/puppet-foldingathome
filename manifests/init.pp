# @summary Installs the folding@home client
#
#
# @param gpu_enable Indicates if the GPU should be enabled
# @param user_name Specify your folding@home stats username
# @param allow Specify IPs that can access the web control client remotely
# @param web_allow Specify IPs that can access the web control client remotely
# @param tean_id Team ID that your contributing to
# @param url Download URL for the Folding@Home Client Installer
# @param cpu_slots Number of CPU threads to run on this system
# @param web_password Password for remote access to the web console
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
  $cpu_slots = 1,
  $web_password = undef,
) {

  file {'/tmp/fahclient.deb':
    ensure => present,
    source => $url
  }

  package {'fahclient':
    ensure   => installed,
    provider => 'dpkg',
    source   => '/tmp/fahclient.deb',
    require  => File['/tmp/fahclient.deb']
  }

  service {'FAHClient':
    ensure  => running,
    require => Package['fahclient']
  }

  file {'/etc/fahclient/config.xml':
    ensure  => file,
    content => epp('foldingathome/config.xml.epp'),
    require => Package['fahclient'],
    notify  => Service['FAHClient']
  }
}
