require "pillar_kata/version"

module PillarKata
  
  class VendingMachine
    attr_accessor :total_deposit, :coin_return

    def initialize
      @total_deposit = 0
      @coin_return = 0
      display
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
        unrounded_value = @total_deposit + value
        @total_deposit = ('%.2f' % unrounded_value).to_f
      end
    end

    def display
      if @total_deposit > 0
        @display = '%.2f' % @total_deposit
      else
        "INSERT COIN"
      end
    end

    def add_coin(weight_in_g, diameter_in_mm)
      coin_value = evaluate_coin_by_weight_and_size(weight_in_g, diameter_in_mm)
      add_to_total_deposit_or_coin_return(coin_value)
      display
    end
  end

end
