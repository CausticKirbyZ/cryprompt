require "../src/cryprompt"
require "yaml"

#yaml complete config
# _description is a key entry to describe the option
yaml = YAML.parse "
---
hello:
  _description: this is a description for the key HELLO
  to:
    - you
    - person
    - name
  world:
    - end
    - of 
    - my
    - happiness
Goodbye: 
  _description: this is a description field for Goodbye
  my: 
    - sweet 
    - buttery
    - popcorn
    - superlonglinewitha spacedesignedtobreakstuff
    - SpecialSymbols!@#$%^&*()_1234567890-={}[]|'\";:/.<.,?<~~
    - yay
    - more
    - options
    - in 
    - a
    - list
  thing: 
  maybe:
    - this 
    - wont 
    - work 
exit:
  _description: Exits the program
whoami:
  _description: Runs the whoami command 
clear:
  _description: Clears the screen
"

json = JSON.parse %(
{
    "hello": {
        "to": [
            "you",
            "person",
            "name"
        ],
        "world": [
            "end",
            "of",
            "my",
            "happiness"
        ]
    }
}
)

# puts "YAML"
# yaml is hash
# if y = yaml.as_h?
#     y.each do |k,v|
#         p k
#     end
# end


t = CryPrompt::CryPrompt.new();
t.autocomplete.completion = yaml
t.autocomplete.update_suggestions()
# t.prompt = "newprompt! > "
t.set_prompt [ "( ".colorize( :green ) , "my ", "new".colorize(:blue).back(:red).underline.blink , "prompt" , ")".colorize(:green) , "> ".colorize(:red)  ]

t.autoprompt = true


while true 
    begin 
        ans = t.ask()
    rescue e : CryPrompt::Ctrl_C_Exception
        # puts "You pressed ctrl+c "
        ans = nil 
    end
    if ans
        break if ans.downcase.strip() == "exit"
        case ans.downcase.strip  
        when"history"
            # puts t.history.size
            puts t.history
        when "clear"
            system("clear")
        when "whoami"
            system "whoami"
        when "hello world"
            puts "Hello to you too!!"
        end

    end
end 