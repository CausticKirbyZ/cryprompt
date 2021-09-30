# reads a keypress and returns it as a string
    # returns nil if no bytes read 
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


while true 
    f = read_char 
    p f 
    if f == "\u0003"
         exit 0 
    end

end
