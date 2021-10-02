require "json"
require "yaml"
require "colorize"
require "math"
require "./keys"

module CryPrompt
    class AutoComplete 
        property completion : (JSON::Any | YAML::Any | Nil) = nil

        def initialize()

        end

        def initialize(@completion)
        end



        # returns the suggestions for a line based on the completion hash
        def suggestions(line : String, completion = @completion)
          if !completion.nil? # if completion is a hash. ie will it have sub options 
            sugs = [] of String
            comp = completion.as_h?
            if comp
              # create init suggestion list 
              comp.each do |k, v| 
                sugs << k.to_s 
              end  
            else
              comp = completion.as_a? # if not a hash it should be an array being the final options 
              if comp
                # create init suggestion list 
                comp.each do |i| 
                  sugs << i.to_s 
                end
              end
            end
    
            # do the suggest on the actuall last word in the line
            if sugs.size > 0
              # suggest_print(sugs) 
              spl = line.split(" ")
              if spl.size > 1 
                # if more than one word recurse without the first word and suggest on that if the first word is in the mapping
                begin 
                  sugs = suggestions(line.split(" ")[1..].join(" "), completion[ spl[0] ] ) if sugs.includes? spl[0].strip(" ")
                rescue 
                  # clear_nextline() # clear the line if fail 
                end
              else
                # suggest_print( sugs, spl[0] )
                return sugs # return the suggestions 
              end
            end
            return sugs      
          end
        end




        # will render a suggestion box just below the word the person is typing 
        def render(opts : Array(String), current_line_index, word)
            # clear the next 5 or 6 lines 
            # take 5 lines 
            # set background to gray for printed lines 
            # draw a box with the ┐ └  ┘ ┌
            # 

            max_size = 0 
            opts.each do |i|
                if max_size < i.size  
                    max_size = i.size 
                end
            end


            clear_x_below(6, current_line_index)
            print "\n" # move to next line 
            # "┌─".colorize.fore(:green).mode(:bold)
            word_start = current_line_index
            # get to below the word 
            # print Keys::RightArrow * current_line_index
            print "#{" " * (current_line_index)}┌#{"─" * ( max_size + 4 ) }┐".colorize.fore(:green).mode(:bold)            
            print "\n"
            opts[0..Math.min(5,opts.size)].each do |opt|
                print " " * (current_line_index)
                print "│ ".colorize.fore(:green).mode(:bold)
                print opt 
                print " " * (max_size - opt.size)
                print "   │\n".colorize.fore(:green).mode(:bold)
            end
            print "#{" " * (current_line_index)}└#{"─" * (max_size + 4 ) }┘".colorize.fore(:green).mode(:bold)

            print Keys::UpArrow * Math.min(7, opts.size + 2 ) # need to account for the 2 boarder spaces
            print "\r"
            print Keys::RightArrow * ( current_line_index + word.size )




        end


        def chose_from_render()

        end


        def clear_line_below(current_line_index)
          print "\n"
          print " " * 100
          print "\r#{Keys::UpArrow}#{Keys::RightArrow * current_line_index}"
        end


        def clear_x_below(number_of_lines, current_line_index)
          number_of_lines.times do 
            print "\n"
            print " " * 100
          end
          print Keys::UpArrow * number_of_lines
          print "\r#{Keys::RightArrow * current_line_index}"
        end
  

        # bash style single line tab suggest 
        def print_suggestions(opts : Array(String), word : String = "", current_line_index : Int32 = 0 )
            return if opts.size < 1  # do nothing if no suggestions 
            clear_line_below(current_line_index)
            
            # start the suggestion
            print "\n" # down to new line 
            # print " " * (@prompt.size + @current_line.size) # go to current spot
            beg_linepos = 0 
            



            # print @tabcyclecount.to_s + " "
            #print the suggestions below
            opts.each do |o|
                print "#{o}  "
            end
            
            print "\r"   # go to beginning 
            print Keys::UpArrow # go back up 
            print Keys::RightArrow * current_line_index

        end




        


















          
        # end code
    end
end