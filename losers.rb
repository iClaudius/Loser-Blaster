
class Loser
    SPEED = 2.5
    attr_reader :x, :y, :radius

    def initialize(window, image) 
        @radius = 40
        @x = rand(window.width - 2 * @radius) + @radius
        @y = 0 
        @image = Gosu::Image.new(image)
        @window = window 
    end 

    def move 
        @y += SPEED
    end 

    def draw
        @image.draw(@x - @radius, @y - @radius, 1)
    end 

end 