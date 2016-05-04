class pe_mco_shell_agent (
  $libdir  = $pe_mco_shell_agent::params::libdir,
  $owner   = $pe_mco_shell_agent::params::owner,
  $group   = $pe_mco_shell_agent::params::group,
  $mode    = $pe_mco_shell_agent::params::mode,
  $service = $pe_mco_shell_agent::params::service,
) inherits pe_mco_shell_agent::params {
  $base = "${libdir}/mcollective"

  File {
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
    notify => Anchor['mco_shell_notify'],
  }

  # This anchor conditionally notifies the pe-mcollective service, but only if
  # it exists. It is implemented this way to avoid a hard-dependency on
  # Service['pe-mcollective'] being defined. If the service doesn't exist in
  # the catalog this is a no-op.
  anchor { 'mco_shell_notify': } ~> Service <| title == $service |>

  file { "${base}/agent/shell":
    ensure => directory,
  }
  file { "${base}/agent/shell/job.rb":
    source => "puppet:///modules/${module_name}/agent/shell/job.rb",
  }
  file { "${base}/agent/shell.ddl":
    source => "puppet:///modules/${module_name}/agent/shell.ddl",
  }
  file { "${base}/agent/shell.rb":
    source => "puppet:///modules/${module_name}/agent/shell.rb",
  }
  file { "${base}/application/shell.rb":
    source => "puppet:///modules/${module_name}/application/shell.rb",
  }
  file { "${base}/application/shell":
    ensure => directory,
  }
  file { "${base}/application/shell/prefix_stream_buf.rb":
    source => "puppet:///modules/${module_name}/application/shell/prefix_stream_buf.rb",
  }
  file { "${base}/application/shell/watcher.rb":
    source => "puppet:///modules/${module_name}/application/shell/watcher.rb",
  }

}
