module PillarKata
  
  class VendingMachine
    attr_accessor :total_deposit, :coin_return, :product_dispensed, 
                  :inventory, :exact_change_only, :display

    def initialize
      assign_starting_variables
    end

    def evaluate_coin_by_weight_and_size(weight, diameter)
      if weight == 5.000 && diameter == 21.21
        0.05
      elsif weight == 2.268 && diameter == 17.91
        0.10
      elsif weight == 5.670 && diameter == 24.26
        0.25
      elsif weight == 2.500 && diameter == 19.05
        0.01
      end
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

    def show_total_deposit
      if @total_deposit > 0
        @display = truncate_decimals_to_two(@total_deposit)
      else
        @display = show_insert_coin_or_exact_change_only
      end
    end

    def reset_machine_or_show_total_deposit
      if @product_dispensed != nil
        assign_starting_variables
      else
        show_total_deposit
      end
    end

    def return_button_pressed      
      @coin_return = convert_decimalstring_to_float(@coin_return += @total_deposit)
    end

    def activate_exact_change
      @exact_change_only = true
      @display = show_insert_coin_or_exact_change_only
    end


    private

    def assign_starting_variables
      @total_deposit = 0
      @coin_return = 0
      @product_dispensed = nil
      @inventory = { cola: 1, chips: 1, candy: 1 }
      @exact_change_only = false
      @display = show_insert_coin_or_exact_change_only
    end

    def show_insert_coin_or_exact_change_only
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
  end

end