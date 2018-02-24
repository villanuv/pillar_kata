require "pillar_kata/version"

module PillarKata
  
  class VendingMachine
    attr_accessor :total_deposit, :coin_return, :display

    def initialize
      @total_deposit = 0
      @coin_return = 0
      @display = "INSERT COIN"
    end

    def evaluate_coin_by_weight_and_size(weight_in_g, diameter_in_mm)
      if weight_in_g == 5.000 && diameter_in_mm == 21.21
        0.05
      elsif weight_in_g == 2.268 && diameter_in_mm == 17.91
        0.10
      elsif weight_in_g == 5.670 && diameter_in_mm == 24.26
        0.25
      elsif weight_in_g == 2.500 && diameter_in_mm == 19.05
        0.01
      end
    end

    def add_to_total_deposit_or_coin_return(value)
      if value == 0.01
        @coin_return += value
      else
        @total_deposit += value
      end
    end
  end

end
