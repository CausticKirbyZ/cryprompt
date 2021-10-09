module CryPrompt

    class History

        # Set the maximum size of the stored history 
        property historysize : Int32 = 250
        # property size : Int32
        # Not 100% sure what i want this for yet
        property index : Int32 = 0


        def initialize
            @history = [] of String 
            # @history << ""
        end

        def to_s(io : IO)
            c = 0
            @history.each do |i|
                io << "\n" if c > 0
                io << i 
                c += 1
            end
        end

        def size()
            return @history.size 
        end


        # Adds a line to the history
        def <<(line : String)
            # @index += 1 if @index == 0 
            # @history << line
            @history.unshift line
            # @history.insert(@history.size, line) 
            # @index += 1
            while @history.size > @historysize
                @history.shift
                # @index = @history.size 
            end
            if @index >= @history.size 
                @index = @history.size - 1 
            end
        end

        # Same thing as << 
        def add(line : String)
            # @index += 1 if @index == 0 
            
            # @history.insert(@history.size, line) 
            # @history << line
            @history.unshift line
            # @index += 1
            while @history.size > @historysize
                @history.shift
                # @index = @history.size 
            end
            if @index >= @history.size 
                @index = @history.size - 1 
            end
        end

        # Returns the history line at the specified index. 
        def [](index : Int32)
            @history[i]
        end

        # returns the line in the history that the 
        def current_line()
            return "" if @history.size < 1 
            @history[@index] 
        end

        # increments the history index by 1
        def up
            return nil if @history.size < 1 
            # print "#{@index} "
            temp = @history[@index]
            @index += 1
            if @index >= @history.size   
                @index = @history.size - 1
                # @index = @history.size - index 
            end
            return temp 
        end

        # moves the 
        def down
            # print "#{@index} "
            @index -= 1
            if @index < 0 
                @index = 0
                return "" # set to blank line to clear the line if they scroll back down
                #@index = @history.size - 1 
            end
            return @history[@index ]
        end



    end

end