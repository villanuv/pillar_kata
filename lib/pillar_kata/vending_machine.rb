module PillarKata
  
  class VendingMachine
    attr_accessor :total_deposit, :coin_return, :product_dispensed, 
                  :inventory, :safe_box_amount, :exact_change_only, :display

    def initialize
      assign_starting_variables
    end

    def evaluate_coin_by_weight_and_size(weight, diameter)
      added_coin = { weight: weight, diameter: diameter }
      nickel     = { weight: 5.000, diameter: 21.21, value: 0.05 }
      dime       = { weight: 2.268, diameter: 17.91, value: 0.10 }
      quarter    = { weight: 5.670, diameter: 24.26, value: 0.25 }
      penny      = { weight: 2.500, diameter: 19.05, value: 0.01 }
      all_coins  = [nickel, dime, quarter, penny]
      all_coins_as_array_values = all_coins.map {|coin_object| coin_object.values}
      id_coin_by_difference = all_coins_as_array_values.map {|coin_array| coin_array - added_coin.values}
      id_coin_by_difference.select {|array| array.length == 1}.flatten![0]
    end

    def add_to_total_deposit_or_coin_return(value)
      if value == 0.01
        @coin_return += value
      else
        unrounded_total_deposit = @total_deposit + value
        @total_deposit = convert_decimalstring_to_float(unrounded_total_deposit)
        @display = "#{@total_deposit}"
      end
    end

    def add_coin(weight_in_g, diameter_in_mm)
      coin_value = evaluate_coin_by_weight_and_size(weight_in_g, diameter_in_mm)
      add_to_total_deposit_or_coin_return(coin_value)
      @display = truncate_decimals_to_two(@total_deposit)
    end

    def check_for_change(deposit, product_price)
      @coin_return = convert_decimalstring_to_float(deposit - product_price)
    end

    def product_available_selected(product, amount)
      if is_total_deposit_enough_for_product?(product, amount)
        @product_dispensed = product.name
        check_for_change(amount, product.price) unless @exact_change_only
        @display = "THANK YOU"
      else
        @display = "PRICE " + truncate_decimals_to_two(product.price)
      end
    end

    def product_button_pressed(product, amount)
      if @inventory[product.name.to_sym] == 0
        @display = "SOLD OUT"
      else
        product_available_selected(product, amount)
      end
    end

    def show_total_deposit_or_initial_message
      if @total_deposit > 0
        @display = truncate_decimals_to_two(@total_deposit)
      else
        @display = choose_initial_message
      end
    end

    def reset_or_show_total_or_message
      if @product_dispensed != nil
        assign_starting_variables
      else
        show_total_deposit_or_initial_message
      end
    end

    def return_button_pressed      
      @coin_return = convert_decimalstring_to_float(@coin_return += @total_deposit)
    end


    private

    def assign_starting_variables
      @total_deposit = 0
      @coin_return = 0
      @product_dispensed = nil
      @inventory = { cola: 1, chips: 1, candy: 1 }
      @safe_box_amount = 0.10
      @exact_change_only = false
      @display = choose_initial_message
    end

    def choose_initial_message
      @exact_change_only ? "EXACT CHANGE ONLY" : "INSERT COIN"
    end

    def is_total_deposit_enough_for_product?(product, amount)
      amount >= product.price
    end

    def truncate_decimals_to_two(float)
      '%.2f' % float
    end

    def convert_decimalstring_to_float(float)
      truncate_decimals_to_two(float).to_f
    end

    def safe_box_amount_changes(amount)
      @safe_box_amount = amount
      @safe_box_amount < 0.10 ? @exact_change_only = true : @exact_change_only = false
    end
  end

end