# Currency Unit Converter

This application converts a string representation of a currency value 
(i.e. $12.99) to a list of monetary units that represent the value (i.e. 
$1.00 == 4 quarters).

To install the dependencies:

`bundle install`

Command line usage:

<pre>
    <code>
    usage: main.rb [options]
        -c, --currency  Currency type (USD)
        -v, --value     Currency value to convert to monetary units
    </code>
</pre>

Examples:

`ruby main.rb --value '$12.99'`

Note, if you use a dollar sign, you must quote the string to avoid shell
interpolation as a variable.

`ruby main.rb --value 23.12`
`ruby main.rb --value 15`

Decimal points are optional, but if cents are included, you must use 2 decimal
places. In other words: 0.10 is valid, but 0.1 is not.

While the application anticipates multiple currencies, currently only USD is 
supported.

To run the test suite:

`ruby test/test_all.rb`
