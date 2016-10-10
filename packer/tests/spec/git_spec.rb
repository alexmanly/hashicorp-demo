require 'spec_helper'

describe package('git') do
  it { should be_installed }
end

describe file('/usr/bin/java') do
  it { should be_symlink }
end

describe file('/usr/local/bin/consul') do
	it { should exist }
end

describe file('/usr/local/bin/vault') do
	it { should exist }
end

describe file('/usr/local/bin/nomad') do
	it { should exist }
end