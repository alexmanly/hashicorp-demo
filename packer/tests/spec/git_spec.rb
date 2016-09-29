require 'spec_helper'

describe package('git') do
  it { should be_installed }
end

describe file('/opt/tomcat_hashidemo_8_0_36') do
	it { should exist }
	it { should be_directory }
end

describe file('/opt/tomcat_hashidemo') do
  it { should be_symlink }
end

