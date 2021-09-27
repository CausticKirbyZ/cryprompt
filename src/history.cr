module CryPrompt

    class History

        # Set the maximum size of the stored history 
        property historysize : Int32 = 250
        
        # Not 100% sure what i want this for yet
        property index : Int32 = 0


        def initialize
            @history = [] of String 
        end


        # Adds a line to the history
        def <<(line : String)
            @history << line
            while @history.size > @historysize
                @history.shift
            end
        end

        # Same thing as << 
        def add(line : String)
            @history << line
            while @history.size > @historysize
                @history.shift
            end
        end

        # Returns the history line at the specified index. 
        def [](index : Int32)
            @history[i]
        end




    end

end