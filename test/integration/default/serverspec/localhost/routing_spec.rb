require_relative '../spec_helper'

describe routing_table do
  it do
    should have_entry(
      :destination => '10.33.0.0/24',
      :interface   => 'em1',
    )
    should have_entry(
      :destination => '10.0.0.0/16',
      :interface   => 'em1',
      :gateway     => '10.33.0.10'
    )
    should have_entry(
      :destination => '172.24.4.0/24',
      :interface   => 'em1',
      :gateway     => '10.33.0.10'
    )
    should have_entry(
      :destination => '192.168.0.0/24',
      :interface   => 'wlan0',
    )
  end
end
