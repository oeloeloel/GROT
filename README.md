# GROT
GROT module for DragonRuby

A collection of useful things for DragonRuby.

# GROT Debug
A debbugging helper.

### Features:
* toggle debug mode
* tick timer: shows the average time used per tick by the developers code
* watch: displays the results of expressions you provide

## Use
Put the GROT files in `mygame/app`. Add this line at the top of main.rb
`require 'app/grot.rb`

To enable the debugger:
`GROT.debug(true)`

To disable the debugger:
`GROT.debug(false)`

To time ticks. Put this at the start of `def tick`:
`GROT.tick_start`

and at the end:
`GROT.tick_end`

To add an expression to watch:
`GROT.watch { expression }`

## Example:

```
require 'app/grot_debug.rb'

def prepare(args)
  args.state.prepared = true
  GROT.debug(true) # must be called ONCE before GROT.tick_start
  GROT.watch { format('Random number: %.3f', rand()) }
  GROT.watch { "It is #{Time.now}" }
end

def tick(args)
  prepare(args) unless args.state.prepared
  GROT.tick_start
  
  # your code
  
  GROT.tick_end
end
```

This will display the following information at the top of the DragonRuby screen:
* FPS (Default. DragonRuby's framerate calculation)
* DT (Default. The amount of time used by your code per tick)
* DS (Default. The number of seconds taken to perform 60 ticks - try to keep it from going over 1)

and the following items that were added to the watch list:
`Random Number: 0.837`
`It is Fri Dec 18 22:55:20 2020`


