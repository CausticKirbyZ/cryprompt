require "./history"
require "./cryprinter"
require "./keys"
require "./input"
require "./autocomplete"

require "json"
require "yaml"

module CryPrompt
    VERSION = "0.0.7"
    
    class CryPrompt
        property history : History
        property prompt : String = "(#{"CryPrompt=".to_s}v#{VERSION})> "
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
            @tab_count  = -1 # keep track of consecutive tabs to cycle through suggestions 
            @line_index = 0 # current cursor index in the current line 
            @word_completion = "" # the part of the word to be completed 
        end


        # This will prompt the user for an input
        # returns a string or nil if nothing is given
        def ask() : String | Nil
            @printer.print_prompt()
            (x = get_line()) ? x : nil
        end

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
                    # @autocomplete.clear_x_below(5, @line_index) 
                    print Keys::ClearScreenBelow # ansi escape code for clearing from cursor to end of terminal. its faster and cleaner than using print \n + " " * 100 or something 
                    completed_there = false 
                end

                if char == Keys::Return# ie they hit enter
                    if  @word_completion != ""
                        @current_line += @word_completion
                        @line_index += @word_completion.size
                        print @word_completion
                        @word_completion = ""
                        @tab_count = -1 
                        next 
                    end
                    
                    break 
                end

                if char == Keys::Ctrl_C # handle ctrl c 
                    
                    print "#{Keys::ClearScreenBelow}\n"
                    raise Ctrl_C_Exception.new("Ctrl C Pressed")
                    return nil
                end

                if char == Keys::Ctrl_D # debug key command
                    puts "#{Keys::ClearScreenBelow}\n\n\tCurrent line:    \"#{@current_line}\"\n\tline_index:      #{@line_index}\n\tword_completion: \"#{@word_completion}\"\n\ttabcount:        #{@tab_count}\n\tSuggestions:      #{@autocomplete.suggestions(@current_line)}\n\n
                    "
                    next 
                end

                # if Keys.alpha_numeric_symbol?(char) || char == " " # if key pressed is something we need to print
                if Keys.ascii_printable? char
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

                else # handle all the escaped/special chars  and also copy and pasted data
                    # if char == Keys::Backspace # remove from current line 
                    #     next if @current_line.size <= 0 
                    #     next if @line_index <= 0
                    #     t = @current_line.split("")
                    #     t.delete_at( @line_index - 1 ) 
                    #     @current_line = t.join
                    #     @line_index -= 1 #  if @line_index > 0
                    # else
                    # end
                    
                    case char 
                    when Keys::Backspace
                        next if @current_line.size <= 0 
                        next if @line_index <= 0
                        t = @current_line.split("")
                        t.delete_at( @line_index - 1 ) 
                        @current_line = t.join
                        @line_index -= 1 #  if @line_index > 0


                    # tab completion
                    when Keys::Tab
                        @tab_count += 1 
                        tabsugs = @autocomplete.suggestions(@current_line)
                        if tabsugs
                            if tabsugs.size == 1 # do the completion for only 1 option 
                                sp = @current_line.split()
                                @word_completion = tabsugs.first[sp.last.size..] # only add the portion of the word that isnt there
                                @line_index = @current_line.size + @word_completion.size + 1
                                @current_line = "#{@current_line}#{@word_completion} "
                                print "\r#{@prompt}#{@current_line}#{Keys::ClearScreenBelow}"

                                @word_completion = ""
                                @tab_count = -1
                                next 
                            elsif tabsugs.size > 1 
                                t = tabcomplete(@tab_count, tabsugs )
                                @word_completion = t if t 
                            end
                        end
                        completed_there = true 
                        next
                    when Keys::Shift_Tab # rotate upwards through list 
                        @tab_count -= 1 unless @tab_count < 0 
                        tabsugs = @autocomplete.suggestions(@current_line)
                        t = tabcomplete(@tab_count,tabsugs)
                        @word_completion = t if t
                        completed_there = true 
                        next
                    
                    
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

                        # when char.size >= 8
                    # else # handle the copy pasted data
                    if Keys.ascii_printable?(char[0]) # if its ascii
                        temp = @current_line.split("")
                        temp2 = char.split ""
                        temp2.each do |c| 
                            # if c == "\n" # need to handle the "\n" char in pasted data somehow but not 100% on how 
                            #     print "\n"
                            #     next
                            # end
                            temp.insert( @line_index, c)
                            @line_index += 1 
                        end
                        # @line_index += char.size
                        @current_line = temp.join("")
                    
                    # end
                        # p "Error How you get here? #{char}"
                        # temp = @current_line.split("")
                        # temp.insert( @line_index, char)
                        # @line_index += temp.size
                        # @current_line = temp.join("")
                    end



                    # next 
                end # end get char while loop

                
                print "\r#{@prompt}#{@current_line} \b"#{@word_completion.colorize.mode(:dim).to_s }" # the space + \b is to make sure that any backspaced char gets removed
                if @line_index < @current_line.size 
                    print Keys::LeftArrow * ( @current_line.size - @line_index ) 
                end

                if autoprompt
                    tabcomplete() unless Keys.is_arrow? char
                end
                @tab_count = -1





            end
            print "#{Keys::ClearScreenBelow}\n" # clear the screen and move to next line
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
                if suggs.size < 1 
                    # @autocomplete.clear_x_below(6, @line_index + @prompt.size)
                    print Keys::ClearScreenBelow
                    return 
                end
                # @autocomplete.print_suggestions(suggs, @current_line.split(" ").last, @line_index)
                @autocomplete.render(suggs, @line_index + @prompt.size - ( @current_line.split(" ").last.size ), @current_line.split(" ").last  )
            end
        end

        def tabcomplete(tabcount, suggs)
            if tabcount <= -1 
                tabcomplete()
                return ""
            end
            # suggs = @autocomplete.suggestions(@current_line)
           

            if suggs # if we have suggestions
                if @tab_count >= suggs.size
                    @tab_count = -1
                end
                if suggs.size < 1 
                    print Keys::ClearScreenBelow
                    return 
                end

                # @autocomplete.print_suggestions(suggs, @current_line.split(" ").last, @line_index)
                return @autocomplete.render(suggs[Math.min(tabcount, Math.max(tabcount - 4, 0))..], @line_index + @prompt.size - ( @current_line.split(" ").last.size ), @current_line.split(" ").last, Math.min(tabcount, 4 )  )
                # @autocomplete.render_box( suggs[Math.min(tabcount,Math.max(tabcount - 4 , 0))..])  # didnt work 
                return ""
            end
            return ""
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
            # print "\r #{" " * 80 }\r#{@prompt}"
            print Keys::ClearScreenBelow
            tmp = @history.up()
            if tmp
                @current_line = tmp 
                @line_index = @current_line.size 
            end
        end

        def downarrowpress()
            # print "\r #{" " * 80 }\r#{@prompt}"
            @current_line = @history.down()
            # @history.down()                        
            @line_index = @current_line.size 
            print "\r#{ Keys::RightArrow * (@prompt.size + @current_line.size) }"
            print Keys::ClearScreenBelow
        end



    end


    class Ctrl_C_Exception < Exception 
    end

end