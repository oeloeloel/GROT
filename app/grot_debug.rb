# GROT DEBUG HELPER
$gtk.reset

# example usage
# require 'app/grot_debug.rb'

# def prepare(args)
#   args.state.prepared = true
#   GROT.debug(true) # must be called ONCE before GROT.tick_start
#   GROT.watch { format('Random number: %.3f', rand()) }
#   GROT.watch { "It is #{Time.now}" }
# end

# def tick(args)
#   prepare(args) unless args.state.prepared
#   GROT.tick_start

#   # your code

#   GROT.tick_end
# end

module GROT
  def self.debug(active, color: [127, 127, 127, 255])
    $grot_debug = active ? Debug.new(color) : nil
  end

  def self.tick_start
    return unless $grot_debug

    $grot_debug.tick_start
  end

  def self.tick_end
    return unless $grot_debug

    $grot_debug.tick_end
  end

  def self.watch(&block)
    return unless $grot_debug

    $grot_debug.watch(&block)
  end

  # the debug class
  class Debug
    attr_accessor :watchlist

    def initialize(color)
      @watchlist = []
      @color = color

      @tick_time = [0]
      @tick_time_sum = 0
      @sys_time_diff = 0
      @system_time = [0]

      watch { "FPS: #{$gtk.current_framerate.to_i}" }
      watch { format('DT: %.3f', @tick_time_sum) }
      watch { format('DS: %.2f', @sys_time_diff.to_f) }
    end

    def watch(&block)
      @watchlist << block
    end

    def tick_start
      @starting = Time.now
    end

    def tick_end
      calc
      render_watchlist
    end

    def calc
      @system_time.unshift(Time.now)
      @tick_time.unshift(@system_time[0] - @starting)
      if @tick_time.length < 60
        @tick_time_sum += @tick_time[0]
      else
        @tick_time_sum += (@tick_time[0] - @tick_time[-1])
        @tick_time.pop
        @system_time.pop
      end
      @sys_time_diff = @system_time[0] - @system_time[-1]
    end

    def render_watchlist
      $gtk.args.outputs.labels << @watchlist.map_with_index do |watched, i|
        {
          x: 5, y: 720 - (i * 20),
          text: watched.call,
          size_enum: -1.5,
          r: @color[0],
          g: @color[1],
          b: @color[2],
          a: @color[3]
        }
      end
    end
  end
end
