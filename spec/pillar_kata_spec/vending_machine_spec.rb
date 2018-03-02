describe PillarKata::VendingMachine do
  before do
    inventory = { cola: 1, chips: 1, candy: 1 }
    safe_box_amount = 0.10
    @vending_machine = PillarKata::VendingMachine.new(inventory, safe_box_amount)
    
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
      it "assigns inventory param to @inventory" do
        expect(@vending_machine.inventory).to eq ({ cola: 1, chips: 1, candy: 1 })
      end

      it "calls #initialize_helper" do
        expect(@vending_machine.safe_box_amount).to eq 0.10
        expect(@vending_machine.exact_change_only).to eq false
        expect(@vending_machine.display).to eq "INSERT COIN"
      end

      it "calls #assign_starting_variables" do
        expect(@vending_machine.total_deposit).to eq 0
        expect(@vending_machine.coin_return).to eq 0
        expect(@vending_machine.product_dispensed).to be_nil
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

        describe "#safe_box_amount" do
          it "gets and sets @safe_box_amount" do
            expect(@vending_machine.safe_box_amount).to eq 0.10
            @vending_machine.safe_box_amount = 0.20
            expect(@vending_machine.safe_box_amount).to eq 0.20
          end
        end

        describe "#exact_change_only" do
          it "gets and sets @exact_change_only" do
            expect(@vending_machine.exact_change_only).to eq false
            @vending_machine.exact_change_only = true
            expect(@vending_machine.exact_change_only).to eq true
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

          it "updates @safe_box_amount" do
            @vending_machine.product_button_pressed(@cola, 1.05)
            expect(@vending_machine.safe_box_amount).to eq 1.10
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

    describe "#reset_or_show_total_or_message" do
      context "when @product_dispensed:" do
        it "updates @inventory" do
          @vending_machine.product_dispensed = "chips"
          @vending_machine.reset_or_show_total_or_message
          expect(@vending_machine.inventory).to eq ({ cola: 1, chips: 0, candy: 1 })
        end

        it "calls #assign_starting_variables, resets machine" do
          @vending_machine.product_dispensed = "chips"
          @vending_machine.reset_or_show_total_or_message
          expect(@vending_machine.total_deposit).to eq 0
          expect(@vending_machine.coin_return).to eq 0
          expect(@vending_machine.product_dispensed).to be_nil
        end

        it "calls #initialize_helper with @safe_box_amount" do
          @vending_machine.product_button_pressed(@cola, 1.05)
          @vending_machine.reset_or_show_total_or_message
          expect(@vending_machine.safe_box_amount).to eq 1.10
          expect(@vending_machine.exact_change_only).to eq false
          expect(@vending_machine.display).to eq "INSERT COIN"
        end
      end

      context "when @total_deposit is NOT enough:" do
        it "calls #show_total_deposit_or_initial_message, shows @total_deposit" do
          2.times { @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter]) }
          @vending_machine.product_button_pressed(@candy, @vending_machine.total_deposit)
          @vending_machine.reset_or_show_total_or_message
          expect(@vending_machine.display).to eq "0.50"
        end
      end

      context "when no @total_deposit:" do
        it "calls #show_total_deposit_or_initial_message, displays INSERT COIN" do
          expect(@vending_machine.total_deposit).to eq 0
          @vending_machine.product_button_pressed(@candy, @vending_machine.total_deposit)
          @vending_machine.reset_or_show_total_or_message
          expect(@vending_machine.display).to eq "INSERT COIN"
        end
      end
    end

    describe "#show_total_deposit_or_initial_message" do
      context "when @total_deposit is NOT enough:" do
        it "shows @total_deposit" do
          2.times { @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter]) }
          @vending_machine.product_button_pressed(@candy, @vending_machine.total_deposit)
          @vending_machine.reset_or_show_total_or_message
          expect(@vending_machine.display).to eq "0.50"
        end
      end

      context "when no @total_deposit:" do
        it "displays INSERT COIN" do
          expect(@vending_machine.total_deposit).to eq 0
          @vending_machine.product_button_pressed(@candy, @vending_machine.total_deposit)
          @vending_machine.reset_or_show_total_or_message
          expect(@vending_machine.display).to eq "INSERT COIN"
        end
      end
    end
  end

  context "MAKE CHANGE" do
    describe "#check_for_change" do
      it "assigns @coin_return to @total_deposit-product.price" do
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

    describe "#show_total_deposit_or_initial_message" do
      context "when @total_deposit is enough:" do
        it "shows @total_deposit" do
          4.times { @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter]) }
          @vending_machine.product_button_pressed(@cola, @vending_machine.total_deposit)
          expect(@vending_machine.display).to eq "SOLD OUT"
          @vending_machine.show_total_deposit_or_initial_message
          expect(@vending_machine.display).to eq "1.00"
        end
      end

      context "when @total_deposit is NOT enough:" do
        it "shows @total_deposit" do
          3.times { @vending_machine.add_coin(@quarter[:weight], @quarter[:diameter]) }
          @vending_machine.product_button_pressed(@cola, @vending_machine.total_deposit)
          expect(@vending_machine.display).to eq "SOLD OUT"
          @vending_machine.show_total_deposit_or_initial_message
          expect(@vending_machine.display).to eq "0.75"
        end
      end

      context "when no @total_deposit:" do
        it "displays INSERT COIN" do
          expect(@vending_machine.total_deposit).to eq 0
          @vending_machine.product_button_pressed(@cola, @vending_machine.total_deposit)
          expect(@vending_machine.display).to eq "SOLD OUT"
          @vending_machine.show_total_deposit_or_initial_message
          expect(@vending_machine.display).to eq "INSERT COIN"
        end
      end
    end
  end

  context "EXACT CHANGE ONLY" do
    before do
      @vending_machine.send(:initialize_helper, 0.05)
    end

    describe "#show_total_deposit_or_initial_message" do
      context "when initialized:" do
        it "displays EXACT CHANGE ONLY" do
          expect(@vending_machine.total_deposit).to eq 0
          @vending_machine.show_total_deposit_or_initial_message
          expect(@vending_machine.display).to eq "EXACT CHANGE ONLY"
        end
      end
    end

    describe "#product_button_pressed" do
      context "when product is available, calls #product_available_selected:" do
        context "when @total_deposit is enough:" do
          it "dispenses product" do
            @vending_machine.product_button_pressed(@cola, 1.00)
            expect(@vending_machine.product_dispensed).to eq "cola"
          end

          it "does NOT call #check_for_change, @coin_return remains 0" do
            @vending_machine.product_button_pressed(@cola, 1.05)
            expect(@vending_machine.coin_return).to eq 0
          end

          it "displays THANK YOU" do
            @vending_machine.product_button_pressed(@cola, 1.00)
            expect(@vending_machine.display).to eq "THANK YOU"
          end
        end

        context "when @total_deposit is NOT enough:" do
          it "does NOT dispense product" do
            @vending_machine.product_button_pressed(@cola, 0.90)
            expect(@vending_machine.product_dispensed).to be_nil
          end

          it "shows PRICE 1.00 for cola" do
            @vending_machine.product_button_pressed(@cola, 0.90)
            expect(@vending_machine.display).to eq "PRICE 1.00"
          end

          it "then displays EXACT CHANGE ONLY" do
            expect(@vending_machine.reset_or_show_total_or_message).to eq "EXACT CHANGE ONLY"
          end
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
    end

    describe "#choose_initial_message", :private do
      context "when @exact_change_only is true:" do
        it "displays EXACT CHANGE ONLY" do
          @vending_machine.exact_change_only = true
          expect(@vending_machine.send(:choose_initial_message)).to eq "EXACT CHANGE ONLY"
        end
      end

      context "when @exact_change_only is false:" do
        it "displays INSERT COIN" do
          expect(@vending_machine.exact_change_only).to eq false
          expect(@vending_machine.send(:choose_initial_message)).to eq "INSERT COIN"
        end
      end
    end

    describe "#is_total_deposit_enough_for_product?", :private do
      it "returns true for cola with 1.00" do
        total_deposit = 1.00
        expect(@vending_machine.send(:is_total_deposit_enough_for_product?, @cola, total_deposit)).to be true
      end

      it "returns true for chips with 0.50" do
        total_deposit = 0.50
        expect(@vending_machine.send(:is_total_deposit_enough_for_product?, @chips, total_deposit)).to be true
      end

      it "returns true for candy with 0.65" do
        total_deposit = 0.65
        expect(@vending_machine.send(:is_total_deposit_enough_for_product?, @candy, total_deposit)).to be true
      end

      context "when more than enough:" do
        it "returns true for any product" do
          total_deposit = 1.00
          expect(@vending_machine.send(:is_total_deposit_enough_for_product?, @candy, total_deposit)).to be true
        end
      end

      context "when NOT enough:" do
        it "returns false for any product" do
          total_deposit = 0.50
          expect(@vending_machine.send(:is_total_deposit_enough_for_product?, @candy, total_deposit)).to be false
        end
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

    describe "#initialize_helper", :private do
      before do
        @vending_machine.send(:initialize_helper, 0.05)
      end

      it "assigns amount param to @safe_box_amount" do
        expect(@vending_machine.safe_box_amount).to eq 0.05
      end

      context "when @safe_box_amount < 0.10" do
        it "assigns @exact_change_only to true" do
          expect(@vending_machine.exact_change_only).to eq true
        end
      end

      context "when @safe_box_amount >= 0.10" do
        it "assigns @exact_change_only to false" do
          @vending_machine.send(:initialize_helper, 0.10)
          expect(@vending_machine.exact_change_only).to eq false
        end

        it "assigns @exact_change_only to false" do
          @vending_machine.send(:initialize_helper, 0.25)
          expect(@vending_machine.exact_change_only).to eq false
        end
      end  

      it "assigns @display to #choose_initial_message" do
        expect(@vending_machine.display).to eq "EXACT CHANGE ONLY"
      end    
    end
  end  
end