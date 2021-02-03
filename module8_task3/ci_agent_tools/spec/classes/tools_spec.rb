# frozen_string_literal: true

require 'spec_helper'

describe 'ci_agent_tools::tools' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      ['vim', 'hugo', 'git'].each do |pkg|
        it { is_expected.to contain_package(pkg) }
      end
    end
  end
end
