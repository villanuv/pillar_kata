require 'spec_helper'

describe PillarKata do
  it 'has a version number' do
    expect(PillarKata::VERSION).not_to be nil
  end
end

describe PillarKata::VendingMachine do
  before do
    @vending_machine = PillarKata::VendingMachine.new
    @nickel = { weight: 5.000, diameter: 21.21, value: 0.05 }
    @dime = { weight: 2.268, diameter: 17.91, value: 0.10 }
    @quarter = { weight: 5.670, diameter: 24.26, value: 0.25 }
    @penny = { weight: 2.500, diameter: 19.05, value: 0.01 }
  end

  context "When customer approaches the machine" do
    describe "#initialize" do
      it "assigns 0 to @total_deposit" do
        expect(@vending_machine.total_deposit).to eq 0
      end

      it "assigns 0 to @coin_return" do
        expect(@vending_machine.coin_return).to eq 0
      end

      it "calls #display" do
        expect(@vending_machine.display).to eq "INSERT COIN"
      end
    end
  end

  context "Accept Coins" do
    describe "#evaluate_coin_by_weight_and_size" do
      it "returns 0.05 for a nickel" do
        expect(@vending_machine.evaluate_coin_by_weight_and_size(@nickel[:weight], @nickel[:diameter])).to eq 0.05
      end

      it "returns 0.10 for a dime" do
        expect(@vending_machine.evaluate_coin_by_weight_and_size(@dime[:weight], @dime[:diameter])).to eq 0.10
      end

      it "returns 0.25 for a quarter" do
        expect(@vending_machine.evaluate_coin_by_weight_and_size(@quarter[:weight], @quarter[:diameter])).to eq 0.25
      end

      it "returns 0.01 for a penny" do
        expect(@vending_machine.evaluate_coin_by_weight_and_size(@penny[:weight], @penny[:diameter])).to eq 0.01
      end
    end

    describe "#add_to_total_deposit_or_coin_return" do
      it "adds nickels to @total_deposit" do
        @vending_machine.add_to_total_deposit_or_coin_return(@nickel[:value])
        expect(@vending_machine.total_deposit).to eq 0.05
      end 

      it "adds dimes to @total_deposit" do
        @vending_machine.add_to_total_deposit_or_coin_return(@dime[:value])
        expect(@vending_machine.total_deposit).to eq 0.10
      end 

      it "adds quarters to @total_deposit" do
        @vending_machine.add_to_total_deposit_or_coin_return(@quarter[:value])
        expect(@vending_machine.total_deposit).to eq 0.25
      end

      it "does NOT add pennies to @total_deposit" do
        @vending_machine.add_to_total_deposit_or_coin_return(@penny[:value])
        expect(@vending_machine.total_deposit).to eq 0.00
      end

      it "places pennies into @coin_return" do
        @vending_machine.add_to_total_deposit_or_coin_return(@penny[:value])
        expect(@vending_machine.coin_return).to eq 0.01
      end       
    end

    describe "#display" do
      it "updates the display when coin deposit is greater than 0.01" do
        @vending_machine.add_to_total_deposit_or_coin_return(@nickel[:value])
        expect(@vending_machine.display).to eq "0.05"
      end
    end

    describe "#add_coin" do
      it "combines the previous 3 methods for Accept Coins feature" do
        @vending_machine.add_coin(@nickel[:weight], @nickel[:diameter])
        expect(@vending_machine.total_deposit).to eq 0.05
        expect(@vending_machine.display).to eq "0.05"
        @vending_machine.add_coin(@dime[:weight], @dime[:diameter])
        expect(@vending_machine.total_deposit).to eq 0.15
        expect(@vending_machine.display).to eq "0.15"
        @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter])
        expect(@vending_machine.total_deposit).to eq 0.40
        expect(@vending_machine.display).to eq "0.40"
        @vending_machine.add_coin(@penny[:weight], @penny[:diameter])
        expect(@vending_machine.total_deposit).to eq 0.40
        expect(@vending_machine.coin_return).to eq 0.01
      end
    end
  end

  context "Select Product" do
    describe "#is_total_deposit_enough_for_product?" do
      it "returns true for cola with $1.00" do
        total_deposit = 1.00
        cola = 1.00
        expect(@vending_machine.is_total_deposit_enough_for_product?(cola, total_deposit)).to be true
      end

      it "returns true for chips with $0.50" do
        total_deposit = 0.50
        chips = 0.50
        expect(@vending_machine.is_total_deposit_enough_for_product?(chips, total_deposit)).to be true
      end

      it "returns true for candy with $0.65" do
        total_deposit = 0.65
        candy = 0.65
        expect(@vending_machine.is_total_deposit_enough_for_product?(candy, total_deposit)).to be true
      end

      it "returns true for any product with enough money" do
        total_deposit = 1.00
        product = 0.65
        expect(@vending_machine.is_total_deposit_enough_for_product?(product, total_deposit)).to be true
      end

      it "returns false for any product without enough money" do
        total_deposit = 0.50
        product = 0.65
        expect(@vending_machine.is_total_deposit_enough_for_product?(product, total_deposit)).to be false
      end
    end
  end
end