require "pillar_kata/version"

module PillarKata
  
  class VendingMachine
    attr_accessor :total_deposit, :coin_return, 
                  :product_dispensed, :display

    def initialize
      @total_deposit = 0
      @coin_return = 0
      @product_dispensed = nil
      @display = "INSERT COIN"
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
        @total_deposit = truncate_decimals_to_two(unrounded_total_deposit).to_f
        @display = "#{@total_deposit}"
      end
    end

    def add_coin(weight_in_g, diameter_in_mm)
      coin_value = evaluate_coin_by_weight_and_size(weight_in_g, diameter_in_mm)
      add_to_total_deposit_or_coin_return(coin_value)
      @display = truncate_decimals_to_two(@total_deposit)
    end

    def is_total_deposit_enough_for_product?(product, amount)
      amount >= product.price
    end

    def product_button_pressed(product, amount)
      if is_total_deposit_enough_for_product?(product, amount)
        @product_dispensed = product.name
        @display = "THANK YOU"
      else
        @display = "PRICE #{truncate_decimals_to_two(product.price)}"
      end
    end

    private

    def truncate_decimals_to_two(float)
      '%.2f' % float
    end
  end

  class VendingItem
    attr_accessor :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end
  end
end
