require_relative '../lib/converter'
require 'test/unit'

I18n.enforce_available_locales = false

class TestConverter < Test::Unit::TestCase
    def test_conversion
        result = Converter.main('USD', '$12.00')
        assert_equal(result[0].count, 12, '$12 should equal 12 dollar coins')

        result = Converter.main('USD', '$15.21')
        assert_equal(result[0].count, 15, '$15.21 should equal 12 dollar coins')
        assert_equal(result[1].count, 0, '$0.21 should equal 0 quarters')
        assert_equal(result[2].count, 2, '$0.21 should equal 2 dimes')
        assert_equal(result[3].count, 0, '$0.01 should equal 0 nickles')
        assert_equal(result[4].count, 1, '$0.01 should equal 1 pennies')

        result = Converter.main('USD', '$15,283.73')
        assert_equal(result[0].count, 15283, '$15,283.21 should equal 15283 dollar coins')
        assert_equal(result[1].count, 2, '$0.73 should equal 2 quarters')
        assert_equal(result[2].count, 2, '$0.23 should equal 2 dimes')
        assert_equal(result[3].count, 0, '$0.03 should equal 0 nickles')
        assert_equal(result[4].count, 3, '$0.03 should equal 1 pennies')

        result = Converter.main('USD', '1500')
        assert_equal(result[0].count, 1500, '1500 should equal 1500 dollar coins')
    end
end