require 'level_object/touch_strategy/base'
require 'level_object/base'

module LevelObject
  class Bomb < LevelObject::Base
    attr_accessor :damage

    class << self
      attr_accessor :damage
    end

    def damage
      @damage = self.class.damage
    end

    def image
      @image = @image_registry.image('bomb/bomb.png')
    end

    def explode_images
      %w(explosion_1 explosion_2 explosion_3 explosion_4 empty).map do |file|
        @image_registry.image("bomb/#{file}.png")
      end
    end

    def touch_right(object)
      touch(object)
    end

    def touch_left(object)
      touch(object)
    end

    def touch_top(object)
      touch(object)
    end

    def touch_bottom(object)
      touch(object)
    end

    def touch(object)
      return if touched?
      object.damage(damage)
      @touched = true
      mark_to_destroy
    end

    def touched?
      @touched
    end

    def touch_strategy
      @touch_strategy ||= TouchStrategy::Base.new(self)
    end

    def touch_strategy=(strategy)
      @touch_strategy = strategy
    end

    def animation
      @animation ||= Animation.new(explode_images)
    end
  end
end
