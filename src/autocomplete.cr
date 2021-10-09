require "json"
require "yaml"
require "colorize"
require "math"

require "./keys"
require "./cryprompttrie"

module CryPrompt
    class AutoComplete 
        # load a yaml or json hash to parse from 
        # you still need to call update_suggestions to parse it 
        property completion : (JSON::Any | YAML::Any | Nil) = nil 
        property sugtrie : CryPromptTrie = CryPromptTrie.new()
        
        def initialize()

        end

        def initialize(@completion)
            update_suggestions()
        end

        # recursive function to generate the suggestion trie from a json or yaml structure
        def update_suggestions(completion : ( JSON::Any | YAML::Any ) = @completion, trie : CryPromptTrie = @sugtrie)
            return if completion.nil?
            # load the candidates from the hash
            comp = completion.as_h?
            if comp
                # create init suggestion list 
                comp.each do |key, value|
                    next if key == "_description" # ignore the description field as that is actually part of the parrent node
                    temp_trie = CryPromptTrie.new(key.to_s) # create a node with the word set to the key from the completion hash
                    begin 
                        temp_trie.description = value["_description"].to_s # set description if it exists
                    rescue 
                    end
                    update_suggestions(value, temp_trie)
                    trie << temp_trie
                end  
            else
                comp = completion.as_a? # if not a hash it should be an array
                if comp
                # create init suggestion list 
                    comp.each do |i| 
                        next if i.nil? 
                        temp_trie = CryPromptTrie.new(i.to_s)
                        update_suggestions(i, temp_trie) if i.class == YAML::Any || i.class == JSON::Any
                        trie << temp_trie
                    end
                end
            end
        end
     

        # returns the succestions for the current line
        # def suggestions(line : String, completion = @completion)
        #     return nil if completion.nil? # if completion is a hash. ie will it have sub options 

        #     sugs = [] of String
        #     candidates = [] of String

        #     # load the candidates from the hash
        #     comp = completion.as_h?
        #     if comp
        #         # create init suggestion list 
        #         comp.each do |k, v| 
        #             candidates << k.to_s
        #         end  
        #     else
        #         comp = completion.as_a? # if not a hash it should be an array being the final options 
        #         if comp
        #         # create init suggestion list 
        #             lw = true 
        #             comp.each do |i| 
        #                 candidates << i.to_s 
        #             end
        #         end
        #     end


        #     # do the suggest on the actual word 
        #     if candidates.size > 0
        #         # suggest_print(sugs) 
        #         spl = line.split(" ")
        #         if spl.size > 1 
        #             # if more than one word recurse without the first word and suggest on that if the first word is in the mapping
        #             begin 
        #                 sugs = suggestions(line.split(" ")[1..].join(" "), completion[ spl[0] ] ) if candidates.includes? spl[0].strip(" ")
        #             rescue 
        #                 # clear_nextline() # clear the line if fail 
        #             end
        #         else
        #         # suggest_print( sugs, spl[0] )
        #             candidates.each do |c| 
        #                 sugs << c if c.downcase.starts_with? spl[0].downcase 
        #             end
        #         end
        #     end
        #     return sugs 



        # end


        #returns an array of words from the sugtrie that fall in line with the given line
        def suggestions(line : String, trie = @sugtrie) : Array(String) | Nil
            tpar = [] of String
            return tpar if trie.nil?

            sp = line.split() # split based on spaces
        
            if sp.size < 1 
                trie.nodes_to_string_array().each do |w| 
                        tpar << w 
                    # end
                end
            elsif sp.size == 1 # if we have only 1 word
                if line.split("").last == " " # if the word doesnt end with a space  
                    tmp = trie[sp.first]
                    if tmp
                        tmp.nodes_to_string_array().each do |w| 
                            tpar << w 
                        end
                    end
                else
                    trie.nodes_to_string_array().each do |w| 
                        tpar << w if w.starts_with? line
                    end
                end       
            elsif sp.size > 1
                tpar = suggestions(line[(sp.first.size + 1)..], trie[sp.first])
            end
            return tpar
        end




        # will render a suggestion box just below the word the person is typing 
        def render(opts : Array(String), current_line_index, word, tabc = -1 )
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

            if max_size < 10
                max_size = 10 
            end
            returnable = ""

            str = String.build do |str|

                # clear_x_below(7, current_line_index)
                print Keys::ClearScreenBelow
                
                str << "\n" # move to next line 
                # "┌─".colorize.fore(:green).mode(:bold)
                word_start = current_line_index
                # get to below the word 
                # print Keys::RightArrow * current_line_index
                str << "#{" " * (current_line_index - 2 )}┌#{"─" * ( max_size + 4 ) }┐\n".colorize.fore(:green).mode(:bold)
                opts[0..Math.min(4,opts.size)].each_with_index do |opt,index|
                    if index == tabc 
                        returnable = opt
                        str <<  " " * (current_line_index - 2)
                        str << "│ ".colorize.fore(:green).mode(:bold)
                        str << opt.colorize.fore(:green).back(:blue).mode(:bold) 
                        str << " " * (max_size - opt.size)
                        str << "   │\n".colorize.fore(:green).mode(:bold)
                    else 
                        str << " " * (current_line_index - 2)
                        str << "│ ".colorize.fore(:green).mode(:bold)
                        str << opt 
                        str << " " * (max_size - opt.size)
                        str << "   │\n".colorize.fore(:green).mode(:bold)
                    end
                end
                str << "#{" " * (current_line_index - 2 )}└#{"─" * (max_size + 4 ) }┘".colorize.fore(:green).mode(:bold) if opts.size <= 5 
                str << "#{" " * (current_line_index - 2 )}└Tab More#{"─" * (max_size - 8 + 4 ) }┘".colorize.fore(:green).mode(:bold) if opts.size > 5 


                str <<  Keys::UpArrow * Math.min(7, opts.size + 2 ) # need to account for the 2 boarder spaces
                str << "\r"
                str << Keys::RightArrow * ( current_line_index + word.size )
            end

            # print the suggestion box 
            print str 


            # return the portion of the highlighted word that isnt typed
            ind = returnable.index(word)
            if ind 
                return returnable[( ind + word.size )..]
            end
            return ""



        end

        # NOT WORKING (probably due to scos/rc)
        # draws the box with the suggestions in it. 
        # selected_index is the index in opts that will be selected to be highlighted
        # max_size is the width of the box 
        # max_suggested is how many items will be suggested at the maximum 
        def render_box(opts : Array(String), selected_index : Int32 = -1, max_suggested : Int32 = 5, min_width_size : Int32 = 4  )
            print Keys::SCOSC # save cursor position 
            print "\n\n\n\n\n"
            print Keys::SCORC 
            print Keys::SCOSC

            
            opts.each do |i| # ensure that the box will be the appropriate size 
                if min_width_size < i.size  
                    min_width_size = i.size 
                end
            end

            str = String.build do |str| # build the box and suggestions as 1 string so we only print once 
                str << Keys::DownArrow # move directly down 
                str << Keys::LeftArrow * 2 # offset so the suggestions are directly underneath the typing 
                
                #start drawing the suggestion box 
                str << "┌#{"─" * ( min_width_size + 4 ) }┐".colorize.fore(:green).mode(:bold)
                opts[0..Math.min(4,opts.size)].each_with_index do |opt,index|
                    str << "\e[#{min_width_size + 6}#{Keys::DownArrow}" # move cursor back to box start and down a line 
                    str << "│ ".colorize.fore(:green).mode(:bold) # next line draw the box 

                    if index == selected_index
                        str << opt.colorize.fore(:green).back(:blue).mode(:bold) 
                    else 
                        str << opt 
                    end

                    str << " " * (min_width_size - opt.size) # pad the rest of the line after opt with spaces
                    str << "│".colorize.fore(:green).mode(:bold) # print the last box 
                end
                str << "└#{"─" * (min_width_size + 4 ) }┘".colorize.fore(:green).mode(:bold)
            end
            print str 


            print Keys::SCORC # restore cursor position to previously saved state 
        end


        def chose_from_render()

        end

        # dont use this just use print Keys::ClearScreenBelow
        def clear_line_below(current_line_index)
          print "\n #{ " " * 100}\r#{Keys::UpArrow}#{Keys::RightArrow * current_line_index}"
        end


        def clear_x_below(number_of_lines, current_line_index)
        #   number_of_lines.times do 
        #     print "\n"
        #     print " " * 100
        #   end
        #   print Keys::UpArrow * number_of_lines
        #   print "\r#{Keys::RightArrow * current_line_index}"
            line = ""
            number_of_lines.times do 
                line += ( "\n" + " " * 100 ) 
            end
            line += "#{Keys::UpArrow * number_of_lines}\r#{Keys::RightArrow * current_line_index}"
            print line 
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