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
        property logging : String | Nil = nil

        def initialize
            @history = History.new()
            @keyboard = Input.new()
            @current_line = "" # this will be the buffer for the current line 
            @ctrl_c_count = 0 
            @printer = CryPrinter.new(prompt)
            @autocompleter = AutoComplete.new(completion)
            @line_index = 0 # current cursor index in the current line 
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
            @line_index = 0
            # get key presses until the user hits enter 
            while true 
                char = @keyboard.read_char()
                next if char.nil? 

                if char == Keys::Return # ie they hit enter d
                    break 
                end

                if char == Keys::Ctrl_C # handle ctrl c 
                    print "\n"
                    @current_line = ""
                    @ctrl_c_count += 1 
                    @line_index = 0
                    return nil if @ctrl_c_count > 1
                    print @prompt
                    next 
                end

                if Keys.alpha_numeric_symbol?(char) || char == " " # if key pressed is something we need to print
                    # @printer.print char
                    # @current_line += char 
                    temp = @current_line.split("")
                    temp.insert( @line_index, char)
                    @line_index += 1 
                    @current_line = temp.join("")

                    # print "\r#{@prompt}#{@current_line}"
                    # if @line_index < @current_line.size 
                    #     print Keys::LeftArrow * ( @current_line.size - @line_index ) 
                    # end


                elsif Keys.is_arrow? char # handle the up/down left/right
                    case char
                    when Keys::LeftArrow 
                        leftarrowpress()
                    when Keys::RightArrow
                        rightarrowpress()
                    when Keys::UpArrow 
                        uparrowpress()
                    when Keys::DownArrow 
                        downarrowpress()                        
                    end
                else 
                    if char == Keys::Backspace && @current_line.size > 0   # remove from current line 
                        t = @current_line.split("")
                        t.delete_at(@line_index - 1 )
                        @current_line = t.join
                        @line_index -= 1 
                        print "\b \b"
                        # @printer.print_char(char)
                        print "\r#{@prompt}#{@current_line} \b"
                        next 
                    else 
                    end
                    # next 
                end

                
                print "\r#{@prompt}#{@current_line}"
                if @line_index < @current_line.size 
                    print Keys::LeftArrow * ( @current_line.size - @line_index ) 
                end





            end
            puts ""
            # clear the current line and let the garbage collector get rid of cl
            @history << @current_line.strip() unless @current_line == "\r"
            cl = @current_line
            @current_line = ""
            @line_index = 0
            return cl 
        end



        def cycle_history()


        end


        def rightarrowpress()
            if @line_index < @current_line.size 
                @line_index += 1 
                print Keys::RightArrow
            end
        end

        def leftarrowpress()
            if @line_index > 0
                @line_index -= 1 
                print Keys::LeftArrow
            end
        end


        def uparrowpress() 
            print "\r #{" " * 80 }\r#{@prompt}"
            @current_line = @history.up()
            # @history.up()
            @line_index = @current_line.size 
        end

        def downarrowpress()
            print "\r #{" " * 80 }\r#{@prompt}"
            @current_line = @history.down()
            # @history.down()                        
            @line_index = @current_line.size 
        end



    end

end