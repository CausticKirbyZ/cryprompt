module CryPrompt
    # all the Key entries for easy reference along with several functions for reading and validating several keytypes
    class Keys

        UpArrow = "\e[A"
        DownArrow = "\e[B"
        RightArrow = "\e[C"
        LeftArrow = "\e[D"

        Insert = "\e[2~"
        Del  = "\e[3~"
        Home = "\e[1~"
        End  = "\e[4~"
        PgUp = "\e[5~"
        PgDown = "\e[6~"

        Backspace = "\u007F"
        Tab = "\t"
        Return = "\r"
        

        F1 = "\eOP"
        F2 = "\eOQ"
        F3 = "\eOR"
        F4 = "\eOS"

        F5 = "\e[15~"
        F6 = "\e[17~"
        F7 = "\e[18~"
        F8 = "\e[19~"
        
        F9 = "\e[20~"
        F10 = "\e[21~"
        # F11 = 
        F12 = "\e[24~"

        
        
        Ctrl_Space = "\u0000"

        Ctrl_A = "\u0001"
        Ctrl_B = "\u0002"
        Ctrl_C = "\u0003"
        Ctrl_D = "\u0004"
        Ctrl_E = "\u0005"
        Ctrl_F = "\u0006"
        Ctrl_G = "\a"
        Ctrl_H = "\b"
        Ctrl_I = "\t"
        Ctrl_J = "\n"
        Ctrl_K = "\v"
        Ctrl_L = "\f"
        Ctrl_M = "\r"
        Ctrl_N = "\u000E"
        Ctrl_O = "\u000F"
        Ctrl_P = "\u0010"
        Ctrl_Q = "\u0011"
        Ctrl_R = "\u0012"
        Ctrl_S = "\u0013"
        Ctrl_T = "\u0014"
        Ctrl_U = "\u0015"
        Ctrl_V = "\u0016"  # not tested 
        Ctrl_W = "\u0017"
        Ctrl_X = "\u0018"
        Ctrl_Y = "\u0019"
        Ctrl_Z = "\u001A"

        # Returns true if a alphanumeric char or symbol ie a-z A-Z 0-9 and !@#$%^&*()_+{}[]|\"':;<>,./?~`"  
        # Does NOT include space
        def self.alpha_numeric_symbol?(char : String )
            if char.class == String 
                return nil if char.size > 1 
                return true if 33 <= char[0].ord <= 126
            end
            return false
        end
        # Returns true if a alphanumeric char or symbol ie a-z A-Z 0-9 and !@#$%^&*()_+{}[]|\"':;<>,./?~`"  
        # Does NOT include space
        def self.alpha_numeric_symbol?(char : Char  )
            return true if 33 <= char.ord <= 126
            return false
        end

        # Returns true if supplied char is an arrow key.
        def self.is_arrow?(char : String  )
            return true if char == UpArrow
            return true if char == DownArrow
            return true if char == LeftArrow
            return true if char == RightArrow
            return false
        end

        # Reads a single character in and returns it as a string.
        def self.read_char() # done 
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