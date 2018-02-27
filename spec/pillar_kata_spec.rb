require 'spec_helper'

describe PillarKata do
  it 'has a version number' do
    expect(PillarKata::VERSION).not_to be nil
  end
end

describe PillarKata::VendingMachine do
  before do
    @vending_machine = PillarKata::VendingMachine.new
    @nickel  = { weight: 5.000, diameter: 21.21, value: 0.05 }
    @dime    = { weight: 2.268, diameter: 17.91, value: 0.10 }
    @quarter = { weight: 5.670, diameter: 24.26, value: 0.25 }
    @penny   = { weight: 2.500, diameter: 19.05, value: 0.01 }
    @cola    = PillarKata::VendingItem.new("cola", 1.00)
    @chips   = PillarKata::VendingItem.new("chips", 0.50)
    @candy   = PillarKata::VendingItem.new("candy", 0.65)
  end

  context "When customer approaches the machine" do
    describe "#initialize" do
      it "calls #assign_starting_variables" do
        expect(@vending_machine.total_deposit).to eq 0
        expect(@vending_machine.coin_return).to eq 0
        expect(@vending_machine.product_dispensed).to be_nil
        expect(@vending_machine.display).to eq "INSERT COIN"
      end

      context "attr_accessor methods" do
        describe "#total_deposit" do
          it "gets and sets @total_deposit" do
            expect(@vending_machine.total_deposit).to eq 0
            @vending_machine.total_deposit = 1
            expect(@vending_machine.total_deposit).to eq 1
          end
        end

        describe "#coin_return" do
          it "gets and sets @coin_return" do
            expect(@vending_machine.coin_return).to eq 0
            @vending_machine.coin_return = 0.01
            expect(@vending_machine.coin_return).to eq 0.01
          end
        end

        describe "#product_dispensed" do
          it "gets and sets @product_dispensed" do
            expect(@vending_machine.product_dispensed).to be_nil
            @vending_machine.product_dispensed = "cola"
            expect(@vending_machine.product_dispensed).to eq "cola"
          end
        end

        describe "#inventory" do
          it "gets and sets @inventory" do
            expect(@vending_machine.inventory[:cola]).to eq 1
            expect(@vending_machine.inventory[:chips]).to eq 1
            expect(@vending_machine.inventory[:candy]).to eq 1
            @vending_machine.inventory[:cola] = 0
            @vending_machine.inventory[:chips] = 0
            @vending_machine.inventory[:candy] = 0
            expect(@vending_machine.inventory[:cola]).to eq 0
            expect(@vending_machine.inventory[:chips]).to eq 0
            expect(@vending_machine.inventory[:candy]).to eq 0
          end
        end

        describe "#display" do
          it "gets and sets @display" do
            expect(@vending_machine.display).to eq "INSERT COIN"
            @vending_machine.display = "THANK YOU"
            expect(@vending_machine.display).to eq "THANK YOU"
          end
        end
      end
    end
  end

  context "ACCEPT COINS" do
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
      it "combines previous methods for Accept Coins feature" do
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

  context "SELECT PRODUCT" do
    describe "#is_total_deposit_enough_for_product?" do
      it "returns true for cola with 1.00" do
        total_deposit = 1.00
        expect(@vending_machine.is_total_deposit_enough_for_product?(@cola, total_deposit)).to be true
      end

      it "returns true for chips with 0.50" do
        total_deposit = 0.50
        expect(@vending_machine.is_total_deposit_enough_for_product?(@chips, total_deposit)).to be true
      end

      it "returns true for candy with 0.65" do
        total_deposit = 0.65
        expect(@vending_machine.is_total_deposit_enough_for_product?(@candy, total_deposit)).to be true
      end

      context "when more than enough:" do
        it "returns true for any product" do
          total_deposit = 1.00
          expect(@vending_machine.is_total_deposit_enough_for_product?(@candy, total_deposit)).to be true
        end
      end

      context "when NOT enough:" do
        it "returns false for any product" do
          total_deposit = 0.50
          expect(@vending_machine.is_total_deposit_enough_for_product?(@candy, total_deposit)).to be false
        end
      end
    end

    describe "#product_button_pressed" do
      context "when product is available, calls #product_available_selected:" do
        context "when @total_deposit is enough:" do
          it "assigns product.name to @product_dispensed" do
            @vending_machine.product_button_pressed(@cola, 1.00)
            expect(@vending_machine.product_dispensed).to eq "cola"
          end

          it "calls #check_for_change, assigns @coin_return to value" do
            @vending_machine.product_button_pressed(@cola, 1.05)
            expect(@vending_machine.coin_return).to eq 0.05
          end

          it "displays THANK YOU" do
            expect(@vending_machine.product_button_pressed(@cola, 1.00)).to eq "THANK YOU"
          end
        end

        context "when @total_deposit is NOT enough:" do
          it "shows PRICE 1.00 for cola" do
            expect(@vending_machine.product_button_pressed(@cola, 0.75)).to eq "PRICE 1.00"
          end

          it "shows PRICE 0.50 for chips" do
            expect(@vending_machine.product_button_pressed(@chips, 0.25)).to eq "PRICE 0.50"
          end

          it "shows PRICE 0.65 for candy" do
            expect(@vending_machine.product_button_pressed(@candy, 0.50)).to eq "PRICE 0.65"
          end
        end
      end
    end

    describe "#reset_machine_or_show_total_deposit" do
      context "when @product_dispensed:" do
        it "calls #assign_starting_variables, resets machine" do
          @vending_machine.product_dispensed = "chips"
          @vending_machine.reset_machine_or_show_total_deposit
          expect(@vending_machine.total_deposit).to eq 0
          expect(@vending_machine.coin_return).to eq 0
          expect(@vending_machine.product_dispensed).to be_nil
          expect(@vending_machine.display).to eq "INSERT COIN"
        end
      end

      context "when @total_deposit is NOT enough:" do
        it "calls #show_total_deposit, shows @total_deposit" do
          2.times { @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter]) }
          @vending_machine.product_button_pressed(@candy, @vending_machine.total_deposit)
          @vending_machine.reset_machine_or_show_total_deposit
          expect(@vending_machine.display).to eq "0.50"
        end
      end

      context "when no @total_deposit:" do
        it "calls #show_total_deposit, shows INSERT COIN" do
          @vending_machine.product_button_pressed(@candy, @vending_machine.total_deposit)
          @vending_machine.reset_machine_or_show_total_deposit
          expect(@vending_machine.display).to eq "INSERT COIN"
        end
      end
    end

    describe "#show_total_deposit" do
      context "when @total_deposit is NOT enough:" do
        it "shows @total_deposit" do
          2.times { @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter]) }
          @vending_machine.product_button_pressed(@candy, @vending_machine.total_deposit)
          @vending_machine.reset_machine_or_show_total_deposit
          expect(@vending_machine.display).to eq "0.50"
        end
      end

      context "when no @total_deposit:" do
        it "shows INSERT COIN" do
          @vending_machine.product_button_pressed(@candy, @vending_machine.total_deposit)
          @vending_machine.reset_machine_or_show_total_deposit
          expect(@vending_machine.display).to eq "INSERT COIN"
        end
      end
    end
  end

  context "MAKE CHANGE" do
    describe "#check_for_change" do
      it "subtracts product.price from @total_deposit, assigns to @coin_return" do
        price = 1.00
        total_deposit = 1.05
        @vending_machine.check_for_change(total_deposit, price)
        expect(@vending_machine.coin_return).to eq 0.05
      end
    end
  end

  context "RETURN COINS" do
    describe "#return_button_pressed" do
      it "places @total_deposit into @coin_return" do
        @vending_machine.add_coin(@nickel[:weight], @nickel[:diameter])
        @vending_machine.add_coin(@dime[:weight], @dime[:diameter])
        @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter])
        @vending_machine.return_button_pressed
        expect(@vending_machine.coin_return).to eq 0.40
      end

      it "accommodates pennies in @coin_return total" do
        @vending_machine.add_coin(@nickel[:weight], @nickel[:diameter])
        @vending_machine.add_coin(@dime[:weight], @dime[:diameter])
        @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter])
        @vending_machine.add_coin(@penny[:weight], @penny[:diameter])
        @vending_machine.return_button_pressed
        expect(@vending_machine.coin_return).to eq 0.41
      end
    end
  end

  context "SOLD OUT" do
    before do
      @vending_machine.inventory[:cola] = 0
    end

    describe "#product_button_pressed" do
      context "when product is NOT available:" do
        it "displays SOLD OUT" do
          4.times { @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter]) }
          @vending_machine.product_button_pressed(@cola, @vending_machine.total_deposit)
          expect(@vending_machine.total_deposit).to eq 1.00
          expect(@vending_machine.display).to eq "SOLD OUT"
        end
      end
    end

    describe "#show_total_deposit" do
      context "when @total_deposit is NOT enough:" do
        it "shows @total_deposit" do
          4.times { @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter]) }
          @vending_machine.product_button_pressed(@cola, @vending_machine.total_deposit)
          @vending_machine.show_total_deposit
          expect(@vending_machine.display).to eq "1.00"
        end
      end

      context "when no @total_deposit:" do
        it "shows INSERT COIN" do
          @vending_machine.product_button_pressed(@cola, 0)
          @vending_machine.show_total_deposit
          expect(@vending_machine.display).to eq "INSERT COIN"
        end
      end
    end
  end

  context "Private Methods" do
    describe "#assign_starting_variables", :private do
      it "assigns 0 to @total_deposit" do
        expect(@vending_machine.total_deposit).to eq 0
      end

      it "assigns 0 to @coin_return" do
        expect(@vending_machine.coin_return).to eq 0
      end

      it "assigns nil to @product_dispensed" do
        expect(@vending_machine.product_dispensed).to be_nil
      end

      it "assigns a default hash to @inventory" do
        expect(@vending_machine.inventory).to be_a Hash
        expect(@vending_machine.inventory[:cola]).to eq 1
        expect(@vending_machine.inventory[:chips]).to eq 1
        expect(@vending_machine.inventory[:candy]).to eq 1
      end

      it "assigns INSERT COIN to @display" do
        expect(@vending_machine.display).to eq "INSERT COIN"
      end
    end

    describe "#truncate_decimals_to_two", :private do
      it "shortens decimals to 2 digits as a string" do
        result = @vending_machine.send(:truncate_decimals_to_two, 1.250000001)
        expect(result).to eq "1.25"
        expect(result).to be_a String
      end
    end

    describe "#convert_decimalstring_to_float", :private do
      it "calls #truncate_decimals_to_two and converts into a float" do
        result = @vending_machine.send(:convert_decimalstring_to_float, 1.250000001)
        expect(result).to eq 1.25
        expect(result).to be_a Float
      end
    end
  end  
end

describe PillarKata::VendingItem do
  before do
    @cola = PillarKata::VendingItem.new("cola", 1.00)
  end

  describe "#initialize" do
    it "assigns name to @name" do
      expect(@cola.name).to eq "cola"
    end

    it "assigns price to @price" do
      expect(@cola.price).to eq 1.00
    end

    context "attr_accessor methods" do
      describe "#name" do
        it "gets and sets @name" do
          expect(@cola.name).to eq "cola"
          @cola.name = "coke"
          expect(@cola.name).to eq "coke"
        end
      end

      describe "#price" do
        it "gets and sets @price" do
          expect(@cola.price).to eq 1.00
          @cola.price = 1.25
          expect(@cola.price).to eq 1.25
        end
      end
    end
  end
end
