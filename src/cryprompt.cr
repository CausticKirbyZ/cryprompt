require "json"
require "yaml"


# TODO: Write documentation for `Cryprompt`
module CryPrompt
  VERSION = "0.1.0"


  class CryPrompt
    property prompt : String = "> ", completion : (JSON::Any | YAML::Any | Nil) = nil, autoprompt : Bool = true


    def initialize()
      @current_line = ""
      @crtl_c_count = 0 
      @history = [] of String 
      @history_max = 250 # not sure anyone would ever go this high but meh why not
      @history_cycle_index = 0
    end


    # supports tab complete based on hash 
    def start()
      @crtl_c_count = 0
      while true 
        print @prompt 
        line = get_line()

        if line.nil?  # user hit crtl + c 
          @crtl_c_count += 1 
          if @crtl_c_count > 1 
            exit 1 
          end 
          puts ""
          next 
        end
        @crtl_c_count = 0 

        puts "" # line prob wont 
        # puts line
        
        next if line.nil?
        if line.strip.downcase == "exit"
          return 
        end 
      end
    end


    # presents the user with a 1 time prompt 
    # will return with the string they provided or nil if they hit Ctrl+C
    def ask() : String | Nil
      print @prompt 
      return get_line()
      
    end

    def get_line()
      c = ' '
      @current_line = "" # reset line to blank
      while c != "\r" # until enter key pressed
        c = read_char()
        next if c.nil?
        if c == "\u0003" # ctrl+c 
          clear_nextline()
          return nil 
        end


        @crtl_c_count = 0 # reset ctrl+c count if not ctrl+c
        if c == "\u0004" # ctrl + d 
          p @current_line
          p @prompt 
          p c
        end
        # system('clear') if # something about ctrl + l
        # if c == "\t"
        printable = print_char(c) # prints the char and sets to nil if non standard char 

        @current_line += c unless printable.nil?
        
        suggest() if suggestable(c) && @autoprompt
          # next
        # end

        # p c 
      end
      return @current_line 
    end


    def suggestable(c) 
      if c[0].ascii? 
        return true 
      end 
      return false
    end

    # takes the current line and runs a completion based on the @completion hash 
    def suggest(line : String = @current_line, completion = @completion)
      # puts "Completion keys: "
      sugs = [] of String
      if !completion.nil?
        comp = completion.as_h?
        if comp
          # create init suggestion list 
          comp.each do |k, v| 
            sugs << k.to_s 
          end  
        else
          comp = completion.as_a?
          if comp
            # create init suggestion list 
            comp.each do |i| 
              sugs << i.to_s 
            end
          end
        end

        # do the suggest on the actual word 
        if sugs.size > 0
          # suggest_print(sugs) 
          spl = line.split(" ")
          if spl.size > 1 
            # if more than one word recurse without the first word and suggest on that if the first word is in the mapping
            begin 
              suggest(line.split(" ")[1..].join(" "), completion[ spl[0] ] ) if sugs.includes? spl[0].strip(" ")
            rescue 
              clear_nextline() # clear the line if fail 
            end
          else
            suggest_print( sugs, spl[0] )
          end
        end




      end
    end
    

    def clear_nextline()
      print "\n" # make sure theres a new line in the terminal
      print " " * 80 # clear the terminal line 
      print "\e[A" # go back up               
      print "\r"   # go to beginning 
      print "\e[C" * (@prompt.size + @current_line.size)
    end



    def suggest_print(opts : Array(String), word : String = "")
      return if opts.size < 1  # do nothing if no suggestions 


      print "\n" # make sure theres a new line in the terminal
      print " " * 80 # clear the terminal line 
      print "\e[A" # go back up and go to current pos
      print "\e[C" * (@prompt.size + @current_line.size)

      # start the suggestion

      # print " " * (@prompt.size + @current_line.size)
      print "\n" # down to new line 
      print " " * (@prompt.size + @current_line.size) # go to current spot
      beg_linepos = 0 
      
      #print the suggestions below
      opts.each do |o|
        if word != "" # if we supplied a word
          print "#{o} " if o.starts_with? word
        else 
          print "#{o} "
        end
        beg_linepos += "#{o} ".size()
      end
      
      print "\r"   # go to beginning 
      print "\e[A" # go back up 
      print "\e[C" * (@prompt.size + @current_line.size)



    end





    # prints the provided char but takes into account special chars like \b \t and escaped chars 
    def print_char(char)
      case char 
      when char[0] == "\e" # controll chars
        print char
        return nil
      when "\u007F" # backspace 
        print "\b \b" # backspace just moves the curson back 1 same as left arrow. so we put a space over the spot to rewrite
        t = @current_line.split("")
        t.pop
        @current_line = t.join
        return nil  
      when "\e[A" # up arrow 
        # print char 
        return nil 
      when "\e[B" # down arrow
        # print char 
        return nil  
      when "\e[C" # right arrow
        print char 
        return nil 
      when "\e[D" # left arrow
        print char 
        return nil 
      when "\r","\t"
        # do nothing
        return nil  
      else 
        print char
      end

      return char

    end


    # reads a keypress and returns it as a string
    # returns nil if no bytes read 
    def read_char() 
      input = ""
      STDIN.raw do |io|
        buffer = Bytes.new(4)
        bytes_read = io.read(buffer) 
        return nil if bytes_read == 0 
        input = String.new(buffer[0, bytes_read])
      end

      input 
    end


  end

  # TODO: Put your code here
end
