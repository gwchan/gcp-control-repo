class profile::patch_mgmt_win (
  Array $blacklist = [],
  Array $whitelist = [],
  String $wsus_server = 'http://gw-win-11.gcp.local:8530',
  String $blackout_window_name = 'End of year change freeze',
  String $blackout_window_start = '2020-12-15T00:00:00+10:00',
  String $blackout_window_end = '2021-01-15T00:00:00+10:00',
) {

  class { 'os_patching':
    patch_window     => 'Week3',
    blackout_windows => { $blackout_window_name =>
      {
        start => $blackout_window_start,
        end   => $blackout_window_end,
      }
    },
  }

  class { 'wsus_client':
    server_url                 => $wsus_server,
    target_group               => 'AutoApproval',
    enable_status_server       => true,
    auto_install_minor_updates => false,
    auto_update_option         => 'NotifyOnly',
    detection_frequency_hours  => 22
  }

  if $facts['os_patching'] {
    $updatescan = $facts['os_patching']['missing_update_kbs']
  }
  else {
    $updatescan = []
  }

  if $whitelist.count > 0 {
    $updates = $updatescan.filter |$item| { $item in $whitelist }
  } elsif $blacklist.count > 0 {
    $updates = $updatescan.filter |$item| { !($item in $blacklist) }
  } else {
    $updates = $updatescan
  }
}
  # Now we can process each update with something like this
  # $updates.each | $kb | {
  #     < some code to install a $kb >
  # }
