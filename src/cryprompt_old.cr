require "json"
require "yaml"
require "colorize"


# TODO: Write documentation for `Cryprompt`
module CryPrompt_old
  VERSION = "0.1.0"


  class CryPrompt_old
    # The prompt users will see when they trigger and ask (think bashes $)
    property prompt : String = "> ", 
    # a completion hash supplied by json or yaml
    completion : (JSON::Any | YAML::Any | Nil) = nil
    # Toggle on a continuous prompt suggestion while typing
    property autoprompt : Bool = true 


    def initialize()
      @current_line = ""
      @crtl_c_count = 0 
      @history = [] of String 
      @history_max = 250 # not sure anyone would ever go this high but meh why not
      @history_cycle_index = 0
      @tabcyclecount = -1
      @tabselect = "" 
    end


    # supports tab complete based on hash 
    def start() # handle some basic items... like ctrl c and exit for testing 
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
      # puts "get line"
      c = ' '
      @current_line = "" # reset line to blank
      while true # until enter key pressed (ie user submitted a line) # does handle tab complete with enter though
        # c != "\r" 
        c = read_char()
        next if c.nil?
        
        if c == "\u0004" # ctrl + d 
          print_debug()
          break 
        end


        if c == "\r"
          if @tabcyclecount != -1  # this will be for tab completion stuff 
            temp = @current_line.split(" ").last
            i = @tabselect.index(temp)
            if i 
              @current_line += @tabselect[(i + temp.size)..]
              print @tabselect[(i + temp.size)..]
              print " "
              @current_line += " "
              suggest() if suggestable(c) && @autoprompt
            end
            @tabcyclecount = -1
            next
          else
            break # otherwise break the loop becuase someone hit enter
          end
        end

        if c == "\u0003" # ctrl+c 
          clear_nextline()
          return nil 
        end
        @crtl_c_count = 0 # reset ctrl+c count if not ctrl+c

        # system('clear') if # something about ctrl + l
        # if c == "\t"
        printable = print_char(c) # prints the char and sets to nil if non standard char 

        @current_line += c unless printable.nil?
        
        if c == "\t"
          tab_complete()
          next
        end
        # puts "do i get her?"
        # reset tabcycle count if a different char is pressed 
        @tabcyclecount = -1
        @tabselect = ""

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

    def tab_complete()

      sugs = get_suggestions()
      return if sugs.nil? 
      # puts sugs.size
      # puts @tabcyclecount

      # if sugs.size < 1 
      #   @tabcyclecount = (@tabcyclecount + 1 ) % sugs.size
      #   return 
      # end


      # get a few new lines for the suggestions box
      # puts "\n" * sugs.size unless sugs.size.nil? || sugs.size > 5 
      # puts "\n" * 5 if sugs.size > 5  
      # if @tabcyclecount < 1 
        suggest()
      # end
    #  puts @tabcyclecount

      # highlight the selected option 



      # hit enter to select 


      @tabcyclecount = (@tabcyclecount + 1 ) % sugs.size unless sugs.size == 1
      if sugs.size == 1  
        @tabcyclecount = (@tabcyclecount + 1 ) % 2 # toggle the thing on and off
      end

      # @tabcyclecount += 1 
    
      # @tabcyclecount += 1

      
      

    end

    def get_suggestions(line : String = @current_line, completion = @completion)

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

        # do the suggest on the actual word 
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
      



      # print @tabcyclecount.to_s + " "
      #print the suggestions below
      opts.each_with_index do |o,i|
        # puts i 
        if word != "" # if we supplied a word
          if o.starts_with? word
            print "#{o} " unless i == @tabcyclecount 
            print "#{o} ".colorize.fore(:green).back(:blue) if i == @tabcyclecount
            @tabselect = o if i == @tabcyclecount # set a value for the currently selected option
          end
        else 
          print "#{o} " unless i == @tabcyclecount 
          print "#{o} ".colorize.fore(:green).back(:blue) if i == @tabcyclecount
          @tabselect = o if i == @tabcyclecount
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
    def read_char() # done 
      input = ""
      STDIN.raw do |io|
        buffer = Bytes.new(4)
        bytes_read = io.read(buffer) 
        return nil if bytes_read == 0 
        input = String.new(buffer[0, bytes_read])
      end

      input 
    end

    # ###DONE
    # Prints debug information about current class variables 
    # 
    def print_debug() 
      puts "

      Debug Info: 
      Current Line:         #{@current_line }
      Control+C Count:      #{@crtl_c_count }
      HistorySize:          #{@history.size}
      HistoryMax            #{@history_max }
      HistoryCycleIndex:    #{@history_cycle_index }
      TabCycleCount:        #{@tabcyclecount}
      Tabselect:            #{@tabselect} 
      
      
      "
    end


  end



  # TODO: Put your code here

end
