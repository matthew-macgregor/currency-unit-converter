require 'money'
require_relative 'currency'

module Converter

    # Converts a string +value+ to an array of unit quantities for the given
    # +currency+. Note: only USD is supported currently.
    def Converter.main(currency, value)
        parser = Currency::get_parser(currency, value)
        units = Currency::get_units('USD')

        amount = parser.evaluate
        if amount == nil
            raise ArgumentError, 'Amount is invalid'
        end
        money = Money.new(amount, 'USD')
        results = []

        units.reduce (money) { |memo, unit|
            # Convert the remaining value to a unit quantity
            quantity, remainder = unit.convert(memo)
            # Keep track of the unit for later
            results << quantity
            # Return the remainder to use with the next unit
            remainder
        }
        results
    end
end