module Presentation

    class TerminalPresenter
        def present(results)
            results.each { |unit|
                # Right-pad display name, left-pad count
                puts '%-30s %15s' % [unit.display_name, unit.count]
            }
        end
    end

    def Presentation.get(which)
        case which
        when 'terminal'
            TerminalPresenter.new
        else
            # Programmer error: raise
            raise ArgumentError, "Invalid presenter: #{which}"
        end
    end
end