require "../src/cryprompt"
require "yaml"

#yaml complete config

yaml = YAML.parse "
---
hello:
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
whoami:
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
t.autoprompt = true


while true 
    begin 
        ans = t.ask()
    rescue e : CryPrompt::Ctrl_C_Exception
        # puts "You pressed ctrl+c "
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