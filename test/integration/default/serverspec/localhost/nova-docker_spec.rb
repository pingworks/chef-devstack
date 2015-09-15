require_relative '../spec_helper'

describe file('/usr/local/lib/python2.7/dist-packages/novadocker/virt/docker/driver.pyc') do
  it { should exist }
end
