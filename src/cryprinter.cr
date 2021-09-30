module CryPrompt
    # class for printing for the prompter. this class will handle all the new lines and suggestions...etc 
    class CryPrinter
        
        property prompt : String

        def initialize(@prompt)
        end

        def print_prompt()
            print @prompt            
        end

        def print(thing)
            STDOUT.print thing
        end

        def print_char(char)
            c = ""
            case char 
            when Keys::Backspace 
                c = "\b \b"
            when Keys::Return 
                c = "\r"
            else 
            end

            STDOUT.print c
        end


        def clear_line_below()
            print "\n" # make sure theres a new line in the terminal
            print " " * 80 # clear the terminal line 
            print "\e[A" # go back up               
            print "\r"   # go to beginning 
            print "\e[C" * (@prompt.size + @current_line.size)
        end


        
    end
end