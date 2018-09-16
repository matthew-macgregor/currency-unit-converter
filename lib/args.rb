require 'slop'

module Args
    def Args.parse_args
        opts = Slop.parse suppress_errors: true do |o|
            o.string '-c', '--currency', 'Currency type (USD)', default: 'USD'
            o.string '-v', '--value', 'Currency value to convert to monetary units', required: true
        end
        return opts
    end
end
