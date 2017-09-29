class Trump 
    
    ROTATION_SPEED = 3
    ACCELERATION = 2
    FRICTION = 0.9 
    attr_reader :x, :y, :angle, :radius

    def initialize(window)
        @x = 200
        @y = 200 
        @angle = 0 
        @image = Gosu::Image.new('images/trump_face.png')
        @font = Gosu::Font.new(30)
        @velocity_x = 0 
        @velocity_y = 0 

        @radius = 20 
        @window = window 
    end 


    def draw
        @image.draw_rot(@x, @y, 1, @angle)
    end 

    def turn_right
        @angle += ROTATION_SPEED
    end 

    def turn_left
        @angle -= ROTATION_SPEED
    end 

    def accelerate
        @velocity_x += Gosu.offset_x(@angle, ACCELERATION)
        @velocity_y += Gosu.offset_y(@angle, ACCELERATION)
    end 

    def move
        @x += @velocity_x
        @y += @velocity_y
        @velocity_x *= FRICTION
        @velocity_y *= FRICTION\

        if @x > @window.width - @radius
            @velocity_x *= -1 
            @angle *= -1
            @x = @window.width - @radius 
        end 

        if @x < @radius 
            @velocity_x *= -1  
            @angle *= -1
            @x = @radius 
        end 

        if @y > @window.height - @radius
            @velocity_y *= -1 
            @y = @window.height - @radius
        end 

    end  
end 