require_relative '../lib/currency'
require 'test/unit'
require 'money'

I18n.enforce_available_locales = false

class TestCurrency < Test::Unit::TestCase

    def test_parser
        parser = Currency::get_parser('USD', '$12.00')
        assert_equal(parser.evaluate, 1200, 'Should evaluate with dollar sign and decimal point')
        parser = Currency::get_parser('USD', '$12')
        assert_equal(parser.evaluate, 1200, 'Should evaluate with dollar sign but no decimal point')
        parser = Currency::get_parser('USD', '12')
        assert_equal(parser.evaluate, 1200, 'Should evaluate with neither dollar sign or decimal point')
        parser = Currency::get_parser('USD', '12.0')
        assert_equal(parser.evaluate, nil, 'Should fail to evaluate without 2 decimal points')
        parser = Currency::get_parser('USD', '1,002,000.00')
        assert_equal(parser.evaluate, 100200000, 'Should properly handle comma-delimited numbers')
        parser = Currency::get_parser('USD', '1,002000.00')
        assert_equal(parser.evaluate, nil, 'Should fail on improperly formatted comma-delimited numbers')
        parser = Currency::get_parser('USD', '1,002,000')
        assert_equal(parser.evaluate, 100200000, 'Should successfully parse comma-delimited numbers without decimals')
        parser = Currency::get_parser('USD', '100')
        assert_equal(parser.evaluate, 10000, 'Should add cents if missing')
        parser = Currency::get_parser('USD', '%%slkjdfksj')
        assert_equal(parser.evaluate, nil, 'Should fail to parse inproper input')
        parser = Currency::get_parser('USD', '-$120')
        assert_equal(parser.evaluate, 12000, 'Should use the absolute value for negative input')
        parser = Currency::get_parser('USD', '0')
        assert_equal(parser.evaluate, 0, 'Should properly handle 0')
        assert_raise(ArgumentError, 'Should fail to get unsupported currency type') {
            Currency::get_parser('GBP', '$12.00')
        }
        parser = Currency::get_parser('USD', '1500')
        assert(parser.has_cents? == false, '1500 has no decimal portion')
        assert(parser.is_valid? == true, '1500 is a valid monetary amount')

        parser = Currency::get_parser('USD', '1500.00')
        assert(parser.has_cents?, '1500.00 has a decimal portion')

    end

    def test_monetary_unit

        # These tests also validate MonetaryUnitQuantification indirectly
        subject = Currency::MonetaryUnit.new(100, 'USD', 'Dollar')
        q, r = subject.convert(Money.new(100, 'USD'))
        assert_equal(q.count, 1, 'A dollar should equal 1 dollar, obviously')
        assert_equal(r, 0, 'Remainder should be 0')

        subject = Currency::MonetaryUnit.new(100, 'USD', 'Dollar')
        q, r = subject.convert(Money.new(120, 'USD'))
        assert_equal(q.count, 1, 'A dollar should equal 1 dollar, obviously')
        assert_equal(r.cents, 20, 'Remainder should be 20 cents')

        subject = Currency::MonetaryUnit.new(25, 'USD', 'Quarter')
        q, r = subject.convert(Money.new(120, 'USD'))
        assert_equal(q.count, 4, 'A dollar should equal 4 quarters')
        assert_equal(r.cents, 20, 'Remainder should be 20 cents') 

    end
end