module PillarKata
  
  class VendingMachine
    attr_accessor :total_deposit, :coin_return, :product_dispensed, 
                  :inventory, :change_in_machine, :exact_change_only, :display

    def initialize(inventory, change_in_machine)
      @inventory = inventory
      initialize_helper(change_in_machine)
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
        @total_deposit = truncate_decimal(unrounded_total_deposit)
        @display = "#{@total_deposit}"
      end
    end

    def add_coin(weight_in_g, diameter_in_mm)
      coin_value = evaluate_coin_by_weight_and_size(weight_in_g, diameter_in_mm)
      add_to_total_deposit_or_coin_return(coin_value)
      @display = money_format_as_string(@total_deposit)
    end

    def check_for_change(deposit, product_price)
      @coin_return = truncate_decimal(deposit - product_price)
    end

    def product_available_selected(product, amount)
      if is_total_deposit_enough_for_product?(product, amount)
        @product_dispensed = product.name
        check_for_change(amount, product.price) unless @exact_change_only
        @change_in_machine = @change_in_machine + amount - @coin_return
        @display = "THANK YOU"
      else
        @display = "PRICE " + money_format_as_string(product.price)
      end
    end

    def product_button_pressed(product, amount)
      if @inventory[string_to_symbol(product.name)] == 0
        @display = "SOLD OUT"
      else
        product_available_selected(product, amount)
      end
    end

    def show_total_deposit_or_initial_message
      if @total_deposit > 0
        @display = money_format_as_string(@total_deposit)
      else
        @display = choose_initial_message
      end
    end

    def reset_or_show_total_or_message
      if @product_dispensed != nil
        @inventory[string_to_symbol(@product_dispensed)] -= 1
        assign_starting_variables
        initialize_helper(@change_in_machine)
      else
        show_total_deposit_or_initial_message
      end
    end

    def return_button_pressed      
      @coin_return = truncate_decimal(@coin_return += @total_deposit)
    end


    private

    def assign_starting_variables
      @total_deposit = 0
      @coin_return = 0
      @product_dispensed = nil
    end

    def choose_initial_message
      @exact_change_only ? "EXACT CHANGE ONLY" : "INSERT COIN"
    end

    def is_total_deposit_enough_for_product?(product, amount)
      amount >= product.price
    end

    def money_format_as_string(float)
      '%.2f' % float
    end

    def truncate_decimal(float)
      money_format_as_string(float).to_f
    end

    def string_to_symbol(string)
      string.to_sym
    end

    def initialize_helper(amount)
      @change_in_machine = amount
      @change_in_machine < 0.10 ? @exact_change_only = true : @exact_change_only = false
      @display = choose_initial_message
    end
  end

end