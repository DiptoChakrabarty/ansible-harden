# frozen_string_literal: true

require 'serverspec'

# Required by serverspec
set :backend, :exec

describe service('monit'), :if => os[:family] != 'redhat' || !os[:release].match(/^8\./) do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/monit/monitrc'), :if => os[:family] == 'ubuntu' do
  it { should be_file }
end
describe file('/etc/monit/conf-available/sshd'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  it { should be_file }
end
describe file('/etc/monit/monitrc.d/sshd'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
  it { should be_file }
end
describe file('/etc/monit/conf.d/sshd'), :if => os[:family] == 'ubuntu' && os[:release] == '12.04' do
  it { should be_file }
end
describe file('/etc/monitrc'), :if => os[:family] == 'redhat' && !os[:release].match(/^8\./) do
  it { should be_file }
end
describe file('/etc/monit.d/sshd'), :if => os[:family] == 'redhat' && !os[:release].match(/^8\./) do
  it { should be_file }
end

describe command("monit status (#{os[:family]}, #{os[:release]})"), :if => os[:family] != 'redhat' || !os[:release].match(/^8\./) do
  its(:stdout) { should match(/monitoring status.*Monitored/) }
  its(:stdout) { should_not match(/monitoring status.*Not Monitored/) }
  its(:exit_status) { should eq 0 }
end
