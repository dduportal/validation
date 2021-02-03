require 'spec_helper_acceptance'

pp_basic = <<-PUPPETCODE
  include ci_agent_tools::tools
PUPPETCODE

idempotent_apply(pp_basic)
