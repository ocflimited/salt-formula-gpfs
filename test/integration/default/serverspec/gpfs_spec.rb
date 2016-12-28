require 'serverspec'

set :backend, :exec

describe package('gpfs.base') do
  it { should be_installed }
end

describe yumrepo('gpfs') do
  it { should exist }
end

describe file('/etc/profile.d/gpfs.sh') do
  it { should exist }
  it { should be_mode 555 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/profile.d/gpfs.csh') do
  it { should exist }
  it { should be_mode 555 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

context linux_kernel_parameter('vm.min_free_kbytes') do
  its(:value) { should be <= 15254502 }
end
