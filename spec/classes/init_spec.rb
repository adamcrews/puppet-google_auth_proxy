require 'spec_helper'

Puppet.features.stubs(:root?).returns(true)

describe 'google_auth_proxy' do
  context 'supported operating systems' do
    ['Debian', 'RedHat', 'Darwin'].each do |osfamily|
      describe "google_auth_proxy class with required parameters on #{osfamily}" do
        let(:params) {{
            :client_id => '123456.foo.bar',
            :client_secret => 'secret',
            :upstreams => [ 'upstream1' ],
        }}

        if osfamily == 'Darwin'
          let(:facts) {{
            :osfamily => osfamily,
            :architecture => 'x86_64',
            :kernel => 'Linux',
          }}
        else
          let(:facts) {{
            :osfamily => osfamily,
            :architecture => 'x86_64',
            :kernel => 'Darwin',
          }}
        end

        it { should compile.with_all_deps }

        it { should contain_class('google_auth_proxy::params') }
        it { should contain_class('google_auth_proxy::install').that_comes_before('google_auth_proxy::config') }
        it { should contain_class('google_auth_proxy::config') }
        it { should contain_class('google_auth_proxy::service').that_subscribes_to('google_auth_proxy::config') }

        it { should contain_service('google_auth_proxy') }
        it { should contain_package('google_auth_proxy').with_ensure('present') }
      end

      describe "google_auth_proxy class with required params on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
          :architecture => 'x86_64',
        }}
        
        it { expect { should compile.with_all_deps }.to raise_error }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'google_auth_proxy class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
        :architecture => 'x86_64',
      }}

      it { expect { should contain_package('google_auth_proxy') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end

  context 'unsupported system architecture' do
    describe 'google_auth_proxy with unsupported architecture' do
      let(:facts) {{
        :osfamily     => 'RedHat',
        :architecture => 'i386',
      }}

      it { expect { should contain_package('google_auth_proxy') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
