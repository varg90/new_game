require 'rubygems'
require 'bundler/setup'
require 'gosu'

ROOT_PATH = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift( File.join( ROOT_PATH, 'lib' ))

require 'camera'
require 'level'
require 'image_registry'


class Window < Gosu::Window

  attr_reader :level
  attr_accessor :debug, :camera

  def initialize(width, height)
    @width = width
    @height = height
    super(width, height, false)
    self.caption = 'Jump, jump!'

    @camera = Camera.new(self)
    @font = Gosu::Font.new(self, 'Courier New', 18)
    @image_registry = ImageRegistry.new(self, '/media/images')
  end

  def update
    if left_pressed?
      player.go_left
    elsif right_pressed?
      player.go_right
    else
      player.stand
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0
      player.jump
    end
    if button_down? Gosu::KbDown
      player.crouch
    end
    player.move
    camera.target(player)
  end

  def reload
    @level.reload
    @camera.target(player)
  end

  def right_pressed?
    button_down? Gosu::KbRight or button_down? Gosu::GpRight
  end

  def left_pressed?
    button_down? Gosu::KbLeft or button_down? Gosu::GpLeft
  end

  def draw
    translate(-camera.x, -camera.y) do
      player.draw
      object_list.draw
    end
    draw_debug! if @debug
    draw_info!
  end

  def draw_debug!
    @font.draw("x:#{player.geometry.x}, y:#{player.geometry.y}", 50, 60, 0)
    @font.draw("vel_x:#{player.vel_x}, vel_y:#{player.vel_y}", 50, 80, 0)
    @font.draw("camera x:#{camera.x}, y:#{camera.x}", 50, 100, 0)
    @font.draw("level w:#{level.width}, h:#{level.height}", 50, 120, 0)
  end

  def draw_info!
    @font.draw("Restart: press R", 800, 60, 0)
  end

  def load_level(lines)
    @level = Level.new(lines, @image_registry)
    @camera.target(player)
  end

  def player
    level.player
  end

  def object_list
    level.object_list
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    elsif id == Gosu::KbR
      reload
    end
  end
end

level = [
    "-----------------------------------------------------------",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                      -   -               -  -  -  -  -  -",
    "-                       ---                               -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                     {                    -  -  -  -  -  -",
    "-            --       {                    -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "--             -    |                      -  -  -  -  -  -",
    "--             -    |                      -  -  -  -  -  -",
    "--             -    |                      -  -  -  -  -  -",
    "--             -    |                      -  -  -  -  -  -",
    "--             -    |                      -  -  -  -  -  -",
    "--             -    |                      -  -  -  -  -  -",
    "--             -    |                      -  -  -  -  -  -",
    "--             -    |                      -  -  -  -  -  -",
    "--             -    |   }                  -  -  -  -  -  -",
    "-                -  |   }                  -  -  -  -  -  -",
    "-                   |   }                  -  -  -  -  -  -",
    "-                   }   }                  -  -  -  -  -  -",
    "-                       }                  -  -  -  -  -  -",
    "-      ---              }                  -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-   -----------                            -  -  -  -  -  -",
    "-                      |                 /--/--/--/--/--/--",
    "-                      |                /  -  -  -  -  -  -",
    "-                      |               /   -  -  -  -  -  -",
    "-                                          -  -  -  -  -  -",
    "-                      }                   -  -  -  -  -  -",
    "-              -       }                   -  -  -  -  -  -",
    "-                      }                   -  -  -  -  -  -",
    "-                      }          /-\\                     -",
    "-                   |  }         /   \\                    -",
    "-                   |  }        /--   \\                   -",
    "-          -        |  }       /-  -   \\                  -",
    "-          -        |  }      /--   -   \\                 -",
    "-          -              x  /---        \\                -",
    "-----------------------------------------------------------"]

window = Window.new(1024, 768)
window.load_level(level)
window.debug = true
window.show
