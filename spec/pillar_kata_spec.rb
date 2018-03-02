require 'spec_helper'

describe PillarKata do
  it 'has a NICKEL constant' do
    expect(PillarKata::NICKEL).to be_a Hash
    expect(PillarKata::NICKEL).to eq ({ weight: 5.000, diameter: 21.21, value: 0.05 })
  end

  it 'has a DIME constant' do
    expect(PillarKata::DIME).to be_a Hash
    expect(PillarKata::DIME).to eq ({ weight: 2.268, diameter: 17.91, value: 0.10 })
  end

  it 'has a QUARTER constant' do
    expect(PillarKata::QUARTER).to be_a Hash
    expect(PillarKata::QUARTER).to eq ({ weight: 5.670, diameter: 24.26, value: 0.25 })
  end

  it 'has a PENNY constant' do
    expect(PillarKata::PENNY).to be_a Hash
    expect(PillarKata::PENNY).to eq ({ weight: 2.500, diameter: 19.05, value: 0.01 })
  end
end