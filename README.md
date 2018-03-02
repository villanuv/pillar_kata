# Vending Machine Kata

The Vending Machine Kata is part of Pillar Technology's application process for their Apprenticeship Program. It is a Test Driven Development exercise that will:

> build the brains of a vending machine. It will accept money, make change, maintain inventory, and dispense products.

> There are three products: cola for $1.00, chips for $0.50, and candy for $0.65.

My solution was written in Ruby and created as a gem to simplify the review process for their Artisans. The gem itself was not meant to be published.

I enjoyed this exercise very much, especially in seeing how my code incrementally improved with each step of TDD. 

### Notes

1. To determine a coin's monetary value, I used values from an online resource to create a hash. Weight and diameter are in grams and millimeters, respectively.
2. The vending machine's #evaluate_coin_by_weight_and_size method was not written to evaluate any other coin outside of a U.S. nickel, dime, quarter or penny. 
3. The total value in a coin return also accommodates pennies.
4. The **Select Product** feature will need to combine its methods through a UI or other front end.
5. For **Exact Change Only**: Products are dispensed if more that enough money is added. In that case, no change will be returned. I determined that a vending machine with only $0.05 in change should trigger @exact_change_only.
6. In developing the last feature, it was clear that the vending machine's total change could be maintained as well. Refactoring revealed initializing an inventory. I have included these as part of my solution.
7. RSpec tests have been organized to show associated methods as appropriate and under their respective features.

## To View RSpec Tests

 1. Clone the repo: `git clone https://github.com/villanuv/pillar_kata`
 2. cd into directory
 3. Run `bin/setup` to install dependencies. 
 4. To run tests: Run `rake spec`

**Optional:** Run `bin/console` to experiment with the gem.

Dependencies installed include: bundler, rake and rspec.

## Console Example

```ruby
# Create vending machine
cola_count, chips_count, candy_count = 1, 1, 1 
change_in_machine = 0.10
@vending_machine = PillarKata::VendingMachine.new(cola_count, chips_count, candy_count, change_in_machine)
# Call #total_deposit method
@vending_machine.total_deposit #=> 0
# Create vending item
@cola = PillarKata::VendingItem.new("cola", 1.00)
# Call #name method
@cola.name #=> "cola"
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).