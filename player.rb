require 'gosu'

# Simple Player class
class Player
    def initialize(bild)
        @bild = bild
        @x = @y = @vel_x = @vel_y = @angle = 0.0 # float
        @score = 0 #int
    end

    def score
        @score
    end

    def collect_stars(stars)
        #stars.reject! do |star| 
         #   if Gosu.distance(@x, @y, star.x, star.y) < 35
          #      @score += 10
           #     @beep.play
            #    true
            #else
             #   false
            #end
        #end
    end

    def warp(x, y)
        @x, @y = x, y
    end

    def go_up
        @y -= 32*$scale
    end

    def go_down
        @y += 32*$scale
    end

    def move
        if @y > $resolution.dig($res, 1)-32*$resolution.dig($res, 2)
            @y = $resolution.dig($res, 1)-32*$resolution.dig($res, 2)
        end
        if @y < 0 
            @y = 0
        end
    end

    def draw
        img = @bild[Gosu.milliseconds / 100 % @bild.size]
        img.draw(@x - img.width / 8.0, @y - img.height / 2.0, ZOrder::STARS, $scale, $scale) # (posX, posY, posZ, scale_x, scale_y)
    end
end