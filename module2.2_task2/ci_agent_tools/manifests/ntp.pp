# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include ci_agent_tools::ntp
class ci_agent_tools::ntp {

  service { 'ntp':
    ensure => 'running',
    enable => 'true';
  }
}
