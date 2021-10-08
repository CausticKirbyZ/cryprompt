module CryPrompt
    # all the Key entries for easy reference along with several functions for reading and validating several keytypes
    class Keys

        UpArrow = "\e[A"
        DownArrow = "\e[B"
        RightArrow = "\e[C"
        LeftArrow = "\e[D"

        Insert = "\e[2~"
        Delete  = "\e[3~"
        Home = "\e[1~"
        End  = "\e[4~"
        PgUp = "\e[5~"
        PgDown = "\e[6~"

        Backspace = "\u007F"
        Tab = "\t"
        Return = "\r"
        Pause = "\u001A"

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


        Ctrl_Insert     =  "\e[2;5~"
        Ctrl_Delete     =  "\e[3;5~"
        Ctrl_Home       =  "\e[1;5H"
        Ctrl_End        =  "\e[1;5F"
        Ctrl_PgUp       =  "\e[5;5~"
        Ctrl_PgDown     =  "\e[6;5~"


        Shift_Tab           = "\e[Z"
        Shift_Delete        = "\e[3;2~"
        Shift_End           = "\e[1;2F"
        # Shift_Insert        = "\\e[6;2~" # NO IDEA?>?? shift insert is pase in linux terminals..... 
        Shift_Home          = "\e[1;2H"
        Shift_PgUp          = "\e[5;2~"
        Shift_PgDown        = "\e[6;2~"

        Shift_UpArrow       = "\e[1;2A"
        Shift_DownArrow     = "\e[1;2B"
        Shift_LeftArrow     = "\e[1;2D"
        Shift_RightArrow    = "\e[1;2C"

        ClearScreen         = "\e[2J"
        ClearScreenBelow    = "\e[J"
        ClearScreenAbove    = "\e[1J"

        SCOSC  = "\e[s"
        SCORC  = "\e[u"


        







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
        def self.alpha_numeric_symbol?( char : Char  )
            return true if 33 <= char.ord <= 126
            return false
        end

        # returns true if ascii printable ()
        def self.ascii_printable?(char : String)
            if char.class == String 
                return nil if char.size > 1 
                return false if char[0].ord == 127 # del 
                return true if 32 <= char[0].ord < 255
            end
            return false 
        end

        # returns true if ascii printable ()
        def self.ascii_printable?(char : Char)
            return false if char.ord == 127 # del 
            return true if 32 <= char.ord < 255
            return false 
        end





        # Returns true if supplied char is an arrow key.
        def self.is_arrow?(char : String  )
            return true if char == Keys::UpArrow
            return true if char == Keys::DownArrow
            return true if char == Keys::LeftArrow
            return true if char == Keys::RightArrow
            return false
        end

        # telss if a char is escaped(its a special char ie starts with \e )
        def self.is_escaped?(char : String )
            char[0] == "\e"
        end
        def self.is_escaped?(char : Char )
            char == "\e"
        end
        
    end
end