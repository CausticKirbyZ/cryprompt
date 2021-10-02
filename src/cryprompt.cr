require "./history"
require "./cryprinter"
require "./keys"
require "./input"
require "./autocomplete"

require "json"
require "yaml"

# TODO: Write documentation for `CryPrompt`
module CryPrompt
    VERSION = "0.0.3"
    
    class CryPrompt

        property history : History 
        property prompt : String = "(#{"CryPrompt="}v#{VERSION})> "
        # property completion : ( JSON::Any | YAML::Any | Nil) = nil
        property autoprompt : Bool = true 
        property logging : String | Nil = nil
        property autocomplete : AutoComplete = AutoComplete.new()

        def initialize
            @history = History.new()
            @keyboard = Input.new()
            @current_line = "" # this will be the buffer for the current line 
            @ctrl_c_count = 0 
            @printer = CryPrinter.new(prompt)
            
            @line_index = 0 # current cursor index in the current line 
        end


        # This will prompt the user for an input
        # returns a string or nil if nothing is given
        def ask() : String | Nil
            @printer.print_prompt()
            (x = get_line()) ? x : nil
        end

        # def update_completions()
        #     @autocompleter = AutoComplete.new(completion)
        # end




        # gets a line from the user 
        # this can handle a decent amount of the logic behind the "terminal feel"
        # ie tab complete, special key handling, suggestions...etc 
        protected def get_line()
            @current_line = ""
            @line_index = 0
            @history.index = 0
            
            completed_there = false 
            # get key presses until the user hits enter 
            while true 
                char = @keyboard.read_char()
                next if char.nil? 
                if completed_there # clear the completed line if there is one
                    @autocomplete.clear_line_below(@line_index) 
                    completed_there = false 
                end

                if char == Keys::Return # ie they hit enter 
                    break 
                end

                if char == Keys::Ctrl_C # handle ctrl c 
                    # raise "Ctrl C Pressed"
                    print "\n"
                    return nil
                    # @current_line = ""
                    # @ctrl_c_count += 1 
                    # @line_index = 0
                    # return nil if @ctrl_c_count > 1
                    # print @prompt
                    # next 
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

                else # handle all the escaped/special chars  
                    if char == Keys::Backspace && @current_line.size > 0 # remove from current line 
                        next if @line_index <= 0
                        t = @current_line.split("")
                        t.delete_at( @line_index - 1 ) 
                        @current_line = t.join
                        @line_index -= 1 #  if @line_index > 0
                    else
                    end
                    
                    case char 
                    when Keys::Tab
                         tabcomplete()
                         completed_there = true 
                    when Keys::Delete
                        next if @line_index >= @current_line.size
                        t = @current_line.split( "" )
                        t.delete_at( @line_index )
                        @current_line = t.join
                    when Keys::Home
                        print "\r#{Keys::RightArrow * @prompt.size}"
                        @line_index = 0
                        next 
                    when Keys::End
                        print "\r#{ Keys::RightArrow * (@prompt.size + @current_line.size) }"
                        @line_index = @current_line.size
                        next 
                    when Keys::PgDown # not sure if i want to do anything with these yet.... hmmm 
                    when Keys::PgUp
                    end



                    # next 
                end

                
                print "\r#{@prompt}#{@current_line} \b" # the space + \b is to make sure that any backspaced char gets removed
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



        def tabcomplete()
            suggs = @autocomplete.suggestions(@current_line)
            if suggs # if we have suggestions
                @autocomplete.print_suggestions(suggs, @current_line.split(" ").last, @line_index)
            end
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