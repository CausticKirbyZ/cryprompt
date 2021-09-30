require "./keys"

module CryPrompt

    # class for getting inputs from the user 
    class Input 
        
        
        def self.read_char()
            read_char() 
        end

        # Reads a single character in and returns it as a string.
        def read_char() # done 
            input = ""
            STDIN.raw do |io|
                buffer = Bytes.new(8)
                bytes_read = io.read(buffer) 
                return nil if bytes_read == 0 
                input = String.new(buffer[0, bytes_read])
            end
        
            input 
        end


        
        

    end
end
