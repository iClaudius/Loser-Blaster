require 'gosu'
require_relative 'trump'
require_relative 'book_bullet'
require_relative 'losers'
require_relative 'explosions'

class LoserBlaster < Gosu::Window
    WIDTH = 800
    HEIGHT = 600
    LOSER_IMAGES = ['images/introspection.png', 'images/rosie.png', 'images/no_losers.png', 'images/islam.png', 'images/truth.png', 'images/china_flag.png']
    LOSER_FREQUENCY = 0.05 

    def initialize
        super(WIDTH, HEIGHT)
        self.caption = "loser blaster!"
        @trump = Trump.new(self)
        @bullets = []
        @explosions = []
        @losers = []
        @background = Gosu::Image.new('images/space_trump.png', tileable: true)
    end 

    def draw
        @trump.draw
        @background.draw(0, 0, 0)

        @bullets.each do  |bullet|
            bullet.draw
        end 

        @losers.each do |loser|
            loser.draw
        end 

        @explosions.each do |explosion|
            explosion.draw
        end 

    end 

    def button_down(id)
        if id == Gosu::KbSpace
            @bullets.push BookBullet.new(self, @trump.x, @trump.y, @trump.angle)
        end 
    end 

    def update
        @trump.turn_left if button_down?(Gosu::KbLeft)
        @trump.turn_right if button_down?(Gosu::KbRight)
        @trump.accelerate if button_down?(Gosu::KbUp)
        @trump.move

        if rand < LOSER_FREQUENCY
            @losers.push Loser.new(self, LOSER_IMAGES[rand(0..LOSER_IMAGES.length-1)] )
        end 

        @losers.each do |loser|
            loser.move 
        end 

        @bullets.each do |bullet|
            bullet.move
        end 

        @losers.dup.each do |loser|
        @bullets.dup.each do |bullet|
            distance = Gosu.distance(loser.x, loser.y, bullet.x, bullet.y)
            if distance < loser.radius + bullet.radius
                @losers.delete loser
                @bullets.delete bullet
                @explosions.push Explosion.new(self, loser.x, loser.y)
            end 
        end 
    end 

    @explosions.dup.each do |explosion|
        @explosions.delete explosion if explosion.finished
    end 

    @losers.dup.each do |loser|
        if loser.y > HEIGHT + loser.radius
            @losers.delete loser
        end 
    end

    @bullets.dup.each do |bullet|
        @bullets.delete bullet unless bullet.onscreen?
    end 

    end 

end 


window = LoserBlaster.new
window.show