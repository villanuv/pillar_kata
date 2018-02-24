require 'spec_helper'

describe PillarKata do
  it 'has a version number' do
    expect(PillarKata::VERSION).not_to be nil
  end
end

describe PillarKata::VendingMachine do
  before do
    @vending_machine = PillarKata::VendingMachine.new
  end

  context "When customer approaches the machine" do
    describe "#initialize" do
      it "assigns 0 to @total_deposit" do
        expect(@vending_machine.total_deposit).to eq 0
      end

      it "assigns 0 to @coin_return" do
        expect(@vending_machine.coin_return).to eq 0
      end

      it "assigns INSERT COIN to @display" do
        expect(@vending_machine.display).to eq "INSERT COIN"
      end
    end
  end
end