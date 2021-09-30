require "./history"
require "./cryprinter"
require "./keys"
require "./input"
require "./autocomplete"

require "json"
require "yaml"

# TODO: Write documentation for `CryPrompt`
module CryPrompt
    VERSION = "0.0.1"
    
    class CryPrompt

        property history : History 
        property prompt : String = "\-\> "
        property completion : ( JSON::Any | YAML::Any | Nil) = nil
        property autoprompt : Bool = true 

        def initialize
            @history = History.new()
            @keyboard = Input.new()
            @current_line = "" # this will be the buffer for the current line 
            @ctrl_c_count = 0 
            @printer = CryPrinter.new(prompt)
            @autocompleter = AutoComplete.new(completion)
        end


        # This will prompt the user for an input
        # returns a string or nil if nothing is given
        def ask() : String | Nil
            @printer.print_prompt()
            (x = get_line()) ? x : nil
        end




        # gets a line from the user 
        # this can handle a decent amount of the logic behind the "terminal feel"
        # ie tab complete, special key handling, suggestions...etc 
        protected def get_line()
            @current_line = ""
            # get key presses until the user hits enter 
            while true 
                char = @keyboard.read_char()
                next if char.nil? 

                if char == Keys::Return # ie they hit enter 
                    break 
                end

                if char == Keys::Ctrl_C # handle ctrl c 
                    print "\n"
                    @current_line = ""
                    @ctrl_c_count += 1 
                    return nil if @ctrl_c_count > 1
                end

                if Keys.alpha_numeric_symbol?(char) || char == " " # if key pressed is something we need to print
                    @printer.print char
                    @current_line += char 
                else 
                    if char == Keys::Backspace # remove from current line 
                        t = @current_line.split("")
                        t.pop
                        @current_line = t.join
                    end
                    @printer.print_char(char)
                    next 
                end

                





            end
            puts ""
            # clear the current line and let the garbage collector get rid of cl
            cl = @current_line
            @current_line = ""
            return cl 
        end



        def cycle_history()


        end



    end

end