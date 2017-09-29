require 'gosu'
require_relative 'trump'
require_relative 'book_bullet'
require_relative 'losers'
require_relative 'explosions'
require_relative 'credit'

class LoserBlaster < Gosu::Window
    WIDTH = 980
    HEIGHT = 600
    LOSER_IMAGES = ['images/introspection.png', 'images/rosie.png', 'images/no_losers.png', 'images/islam.png', 'images/truth.png', 'images/china_flag.png']
    LOSER_FREQUENCY = 0.05 
    MAX_LOSERS = 100

    def initialize
        super(WIDTH, HEIGHT)
        self.caption = "loser blaster!"
        @scene = :start 
        @background = Gosu::Image.new('images/space_trump.png', tileable: true)
        @title_font = Gosu::Font.new(75)
        @prompt_font = Gosu::Font.new(22)
        @press_font = Gosu::Font.new(75)
        
        @title = "LOSER BLASTER!"
        @press = "PRESS ANY KEY!"
        @prompt_1 = "Congratulations. You are millionaire, playboy, steak seller, and reality television star, Donald Trump."
        @prompt_2 = "Unfortunately, life is difficult for you today. "
        @prompt_3 = "There are just too many losers (and muslims) for you to deal with."
        @prompt_4 =  "Not to mention all that China that's been going around lately! Forget it!"
        @prompt_5 = "The good news is that you are not a loser."
        @prompt_6 = "You can blast copies of your book 'The Art of the Deal' from your disgusting face."
        @prompt_7 = "Oh, and the books can be used to blow up your worthless loser enemies too."
        @prompt_8 = "Eat a big one Rosie O'Donnell, and the entire human race!"
        @prompt_9 = "Use Arrows to Fly, Space to Blast."

        @start_music = Gosu::Song.new("sounds/star_spangled.ogg")
        @start_music.play(true)
    

    end 

    def draw 
        case @scene 
        when :start
            draw_start
        when :game
            draw_game
        when :end
            draw_end
        end 
    end 

    def update
        case @scene
        when :game
            update_game
        when :end
            update_end
        end 
    end 

    def button_down(id)
        case @scene
        when :start
            button_down_start(id)
        when :game
            button_down_game(id)
        when :end
            button_down_end(id)
        end 
    end 

    def button_down_start(id)
        initialize_game
    end

    def draw_start
        @background.draw(0, 0, 0)
        @title_font.draw(@title, 265, 50, 1, 1, 1, Gosu::Color::FUCHSIA)
        @prompt_font.draw(@prompt_1, 30, 220, 1, 1, 1, Gosu::Color::AQUA)
        @prompt_font.draw(@prompt_2, 30, 250, 1, 1, 1, Gosu::Color::AQUA)
        @prompt_font.draw(@prompt_3, 30, 280, 1, 1, 1, Gosu::Color::AQUA)
        @prompt_font.draw(@prompt_4, 30, 310, 1, 1, 1, Gosu::Color::AQUA)
        @prompt_font.draw(@prompt_5, 30, 340, 1, 1, 1, Gosu::Color::AQUA)
        @prompt_font.draw(@prompt_6, 30, 370, 1, 1, 1, Gosu::Color::AQUA)
        @prompt_font.draw(@prompt_7, 30, 400, 1, 1, 1, Gosu::Color::AQUA)
        @prompt_font.draw(@prompt_8, 30, 430, 1, 1, 1, Gosu::Color::AQUA)
        @prompt_font.draw(@prompt_9, 30, 460, 1, 1, 1, Gosu::Color::AQUA)

    end 


    def initialize_game
        @trump = Trump.new(self)
        @bullets = []
        @explosions = []
        @losers = []
        @scene = :game
        @losers_appeared = 0 
        @losers_destroyed = 0 
        @game_music = Gosu::Song.new('sounds/donald_trump_jam.ogg')
        @game_music.play(true)
        @explosion_sound = Gosu::Sample.new('sounds/explosion.ogg')
        @shooting_sound = Gosu::Sample.new('sounds/shoot.ogg')
    end 

    def button_down_game(id)
        if id == Gosu::KbSpace
            @bullets.push BookBullet.new(self, @trump.x, @trump.y, @trump.angle)
            @shooting_sound.play(0.3)
        end 
    end 

    def draw_game
        @trump.draw
        @background.draw(0, 0, 0)

        @losers.each do |enemy|
            enemy.draw
        end

        @bullets.each do |bullet|
            bullet.draw
        end 

        @explosions.each do |explosion|
            explosion.draw
        end 
    end

    def update_game
        @trump.turn_left  if button_down?(Gosu::KbLeft)
        @trump.turn_right if button_down?(Gosu::KbRight)
        @trump.accelerate if button_down?(Gosu::KbUp)
        @trump.move

        if rand < LOSER_FREQUENCY
            @losers.push Loser.new(self, LOSER_IMAGES[rand(0..LOSER_IMAGES.length-1)] )
            @losers_appeared += 1
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
                @losers_destroyed += 1
                @explosion_sound.play
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

    initialize_end(:count_reached) if @losers_appeared > MAX_LOSERS
         @losers.each do |loser|
            distance = Gosu.distance(loser.x, loser.y, @trump.x, @trump.y)
            initialize_end(:hit_by_loser) if distance < @trump.radius + loser.radius
        end 

        initialize_end(:off_top) if @trump.y < -@trump.radius

    end 

    def initialize_end(fate)
        case fate 
        when :count_reached
            @message = "Good Job Donald! You destroyed #{@losers_destroyed} losers! Your loins are filled with fire."
            @message2 = "And only #{100 - @losers_destroyed} losers got passed you. You are God." 
        when :hit_by_loser
            @message = "A loser touched you! You, Donald J. Trump!"
            @message2 = "Before you got touched by that loser scum, "
            @message2 += "you managed to blow up #{@losers_destroyed} losers."
        when :off_top 
            @message = "You got too close to the loser control center bro."
            @message2 = "Before you got touched by that loser scum,"
            @message2 += "you managed to blow up #{@losers_destroyed} losers."
        end 

        @bottom_message = "Press P to play again, or Q to quit."
        @message_font = Gosu::Font.new(28)
        @credits = []
        y = 700 

        File.open('credits.txt').each do |line|
            @credits.push(Credit.new(self, line.chomp, 100, y))
            y += 30 
        end 

        @scene = :end 

        @game_music = Gosu::Song.new('sounds/proud_american.wav')
        @game_music.play(true)
    end

    def draw_end
        clip_to(50, 140, 700, 360) do 
            @credits.each do |credit|
                credit.draw
            end 
        end 
        draw_line(0, 140, Gosu::Color::RED, WIDTH, 140, Gosu::Color::RED)
        @message_font.draw(@message, 40, 40, 1, 1, 1, Gosu::Color::FUCHSIA)
        @message_font.draw(@message2, 40, 75, 1, 1, 1, Gosu::Color::FUCHSIA)
        draw_line(0, 500, Gosu::Color::RED, WIDTH, 500, Gosu::Color::RED)
        @message_font.draw(@bottom_message, 180, 540, 1, 1, 1, Gosu::Color::AQUA)
    end  

    def update_end
        @credits.each do |credit|
            credit.move 
        end 

        if @credits.last.y < 150 
            @credits.each do |credit|
                credit.reset
            end 
        end 
    end 

    def button_down_end(id)
        if id == Gosu::KbP
            initialize_game
        elsif id == Gosu::KbQ
            close 
        end 
    end 
end

window = LoserBlaster.new
window.show  