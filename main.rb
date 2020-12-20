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