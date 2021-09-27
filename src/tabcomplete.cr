module CryPrompt
    class TabComplete 
        property completion : (JSON::Any | YAML::Any | Nil) = nil

        def initialize    
        end



        # returns the suggestions for a line based on the completion hash
        def suggestions(line : String, completion = @completion)

            sugs = [] of String
            if !completion.nil? # if completion is a hash. ie will it have sub options 
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
                    sugs = get_suggestions(line.split(" ")[1..].join(" "), completion[ spl[0] ] ) if sugs.includes? spl[0].strip(" ")
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




    end
end