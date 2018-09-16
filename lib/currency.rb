require 'money'

module Currency

    class CurrencyParser_USD

        # Creates a CurrencyParser to convert a string (i.e. $12.99) to cents.
        # (1299) represented by +value+.
        def initialize(value)
            @value = value
            # Adapted from https://stackoverflow.com/questions/354044/what-is-the-best-u-s-currency-regex
            # Changed to only allow 2 decimal places or no decimal places.
            @regex = /^\$?\-?([1-9]{1}[0-9]{0,2}(\,\d{3})*(\.\d{2})?|[1-9]{1}\d{0,}(\.\d{2})?|0(\.\d{2})?|(\.\d{2}))$|^\-?\$?([1-9]{1}\d{0,2}(\,\d{3})*(\.\d{2})?|[1-9]{1}\d{0,}(\.\d{2})?|0(\.\d{2})?|(\.\d{2}))$|^\(\$?([1-9]{1}\d{0,2}(\,\d{3})*(\.\d{2})?|[1-9]{1}\d{0,}(\.\d{2})?|0(\.\d{2})?|(\.\d{2}))\)$/
            @regex_strip = /[^0-9]/
            # Not using the match group above
            @regex_cents = /\.\d{2}/
            # Lazy evaluation
            @match = nil
        end

        # Converts the value string (i.e. $12.99) to an integer representation
        # of cents (1299).
        def evaluate
            result = nil
            if self.is_valid?
                cleansed_str = @value.gsub(@regex_strip, '')
                cleansed_int = cleansed_str.to_i
                if self.has_cents? == false
                    cleansed_int = cleansed_int * 100
                end
                result = cleansed_int
            end
            result
        end

        def is_valid?
            lazy_eval
            @match != nil
        end

        # True if the string representation contains decimal/cents.
        def has_cents?
            (@value =~ @regex_cents) != nil
        end

        # Should be called prior to using the @match member. Used internally,
        # avoid re-evaluation against the currency regex.
        def lazy_eval
            if @value != nil && @match == nil
                @match = @value.match(@regex)
            end
            @match
        end

        private :lazy_eval
    end


    # Represents a quantity of a monetary unit (i.e. 4 quarters).
    class MonetaryUnitQuantification
        attr_reader :count

        def initialize(coin_type, count)
            @coin_type = coin_type
            @count = count
        end

        # Returns the monetary value of the units (i.e. 4 x $0.25 = $1.00).
        # Result is an instance of Money
        def value
            result = @coin_type * @count
            result.display_name = @coin_type.display_name
            return result
        end

        def display_name
            @coin_type.display_name
        end

        def to_s
            "#{@coin_type} count => #{@count}"
        end
    end

    # Abstract representation of a currency unit (dollar, quarter, etc.).
    class MonetaryUnit < Money
        attr_accessor :display_name
    
        def initialize(value, currency, display_name)
            super(value, currency)
            @display_name = display_name
        end
    
        def convert(money)
            count = (money / self).to_i
            remainder = money % self
    
            return MonetaryUnitQuantification.new(self, count), remainder
        end
    
        def to_s
            "#{@display_name} (#{self.cents})"
        end
    end

    def Currency.get_units(currency)
        case currency
        when 'USD'
            [
                MonetaryUnit.new(100, 'USD', 'Dollar Coin'),
                MonetaryUnit.new(25, 'USD', 'Quarter'),
                MonetaryUnit.new(10, 'USD', 'Dime'),
                MonetaryUnit.new(5, 'USD', 'Nickle'),
                MonetaryUnit.new(1, 'USD', 'Penny'),
            ]
        else
            # Programmer error, raise
            raise ArgumentError, "Invalid currency: #{currency}"
        end
    end

    def Currency.get_parser(currency, value)
        case currency
        when 'USD'
            CurrencyParser_USD.new(value)
        else
            # Programmer error, raise
            raise ArgumentError, "Invalid currency: #{currency}"
        end
    end
end