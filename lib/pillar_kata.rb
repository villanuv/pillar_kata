require "pillar_kata/version"

module PillarKata
  
  class VendingMachine
    attr_accessor :total_deposit, :coin_return, :display

    def initialize
      @total_deposit = 0
      @coin_return = 0
      @display = "INSERT COIN"
    end
  end

end
