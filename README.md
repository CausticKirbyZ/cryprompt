# CryPrompt

A crystal library for creating easy prompting cli tools in crystal. I wanted a prompting kit with easy to use tab completion/suggestion while also having a nice easy hierarchy for the suggestion table. Cryprompt also now features a suggestion description in its table with the opional ```_description``` option inside the json or yaml configuration

I am completely open to fixes and suggestions. If there is a better way to do anything i have done please let me know!!

<br>
<img src="./pics/animationdemo2.gif"> 

## Features:
* Text box suggestions 
* easy suggestion path implementaion via yaml/json
* tab complete
* multiple suggestions 
* description options 

## Suggestion Table
The flow of suggested material is in the form of a hash and can be written in json or yaml quite easily. 

ex. 
```yaml
hello: 
  _description: this is a descroption for hello
  to:
    - you
    - jeff
    - jessie 
    - jane
  world:
  everyone:
    _description: this is a description for everyone
    with:
      a:
        _description: this is a description for "a" after "with"
        - hat
        - shirt
        - shoes
        - pants
```

The word "hello" defines the base of this tree and will have 2 sub suggestions "to" and "world".


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     cryprompt:
       github: CausticKirbyZ/cryprompt
       branch: master
   ```

2. Run `shards install`

## Usage

```crystal
require "cryprompt"
```

# Development

## ToDo:
* UPDATE AND DOCUMENT!!!!!! (fix crystal docs) cuz i will come back later and go what was i doing....
* The code is fairly messy.. should be cleaned up 
* ~~hitting tab will autocomplete if only 1 suggestion exists~~
* expose some options to change the autoprompt box color (also address the colored text issues...)
* ~~refactor the autocomplete class to use escape codes for faster/easier cursor management~~ 
* move methods that dont need to be exposed to private 
* ~~do some sort of window size detection so no suggestions are shown unless there is appropriate window size~~ (mostly... could be better but does work)
* windows compatability?? (would probably need to write a different get_char function based on the WM_SYSKEYDOWN function?) will wait on crystal to support windows?

## Bugs:
* pasting with multiple lines is broken. - not sure how to fix... 
* colored prompts will break the location of the cursor apearance due to color codes taking string space... need to fix that


## Contributing

1. Fork it (<https://github.com/your-github-user/cryprompt/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [CausticKirbyZ](https://github.com/CausticKirbyZ) - creator and maintainer

## ShoutOuts 
These 2 repos. I didnt use any of their code but took inspiration on how i wanted the prompt for this library to look
- [CSharpRepl](https://github.com/waf/CSharpRepl) 
- [python-prompt-toolkit](https://github.com/prompt-toolkit/python-prompt-toolkit) 