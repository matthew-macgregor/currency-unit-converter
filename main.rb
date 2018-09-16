require_relative 'lib/args'
require_relative 'lib/converter'
require_relative 'lib/presentation'

I18n.enforce_available_locales = false

def main

    opts = Args.parse_args
    currency = opts[:currency]
    value = opts[:value]

    if value == nil
        puts opts
        exit
    end

    begin
        results = Converter.main(currency, value)
        presenter = Presentation.get('terminal')
        presenter.present(results)
    rescue ArgumentError
        puts "Error: #{$!}"
        puts opts
    end

end

main