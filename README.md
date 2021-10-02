# CryPrompt

A crystal library for creating easy prompting cli tools in crystal.  I Wanted a prompting kit with easy to use tab completion/suggestion while also having a nice easy hierarchy for the suggestion table. 

## Suggestion Table
The flow of suggested material is in the form of a hash and can be written in json or yaml quite easily. 

ex. 
```
---
hello: 
  to:
    - you
    - jeff
    - jessie 
    - jane
  world:
```
the word "hello" defines the base of this tree and will have 2 sub suggestions "to" and "world".






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

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/cryprompt/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [CausticKirbyZ](https://github.com/CausticKirbyZ) - creator and maintainer
