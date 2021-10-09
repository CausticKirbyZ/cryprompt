# CryPrompt

A crystal library for creating easy prompting cli tools in crystal.  I Wanted a prompting kit with easy to use tab completion/suggestion while also having a nice easy hierarchy for the suggestion table. Cryprompt also now features a suggestion description in its table with the opional ```_description``` option

<br>
<img src="./pics/animationdemo.gif"> 

<br>
<img src="./pics/animationdemo2.gif"> 

## Features:
* Text box suggestions  
* easy suggestion path implementaion via yaml/json
* tab complete (mostly)
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
        _description: this is a description for a
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
   ```

2. Run `shards install`

## Usage

```crystal
require "cryprompt"
```

# Development

## ToDo:
* the code is fairly messy.. should be cleaned up 
* hitting tab will autocomplete if only 1 suggestion exists 
* expose some options to change the autoprompt box color 
* refactor the autocomplete class to use escape codes for faster/easier cursor management 


## Bugs:
* pasting with multiple lines is broken. 
* colored prompts will break the location of the cursor apearance... need to fix that


## Contributing

1. Fork it (<https://github.com/your-github-user/cryprompt/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [CausticKirbyZ](https://github.com/CausticKirbyZ) - creator and maintainer
