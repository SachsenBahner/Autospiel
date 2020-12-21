require 'gosu'

#Spieler
class Player
    def initialize(window, bild)
        @bild = bild
        @x = @y = @vel_x = @vel_y = @angle = 0.0 # float
        @score = 0 #int
        @spur = 1 #mittlere spur starten
        @gameWindow = window
    end

    def score
        @score
    end

    def check_collision(gegner)
        gegner.reject! do |enemy| 
            # zunächst Spur checken
            if @spur == enemy.spur
                # jetzt x Koordinate checken
                if @x+(32*$scale) < enemy.x+(32*$scale) && @x+(32*$scale) > enemy.x && @x < enemy.x+(32*$scale)  # X-Koordinate ist auf der Linken Seite des Bildes
                    # jetzt hats geklatscht
                    @select_sound = Gosu::Sample.new("media/crash.ogg")
                    @select_sound.play
                    @gameWindow.switchToMenu
                end
            end
        end
    end

    # drei Spuren

    def warp(x, y)
        @x, @y = x, y
    end

    def go_up
        if @spur < 2
            @spur +=1
        else
            @spur = 2
        end

    end

    def go_down
        if @spur > 0
            @spur -=1
        else
            @spur = 0
        end

    end


    def check_stars(stars)
        stars.reject! do |star| 
            if @spur == star.spur
                # jetzt x Koordinate checken
                if @x+(32*$scale) < star.x+(32*$scale) && @x+(32*$scale) > star.x && @x < star.x+(32*$scale)  # X-Koordinate ist auf der Linken Seite des Bildes
                    # jetzt hats geklatscht
                    @select_sound = Gosu::Sample.new("media/menu_select_sound.ogg")
                    @select_sound.play
                    @score += 1
                    true
                end
            else
                false
            end
        end
    end


    def move
        # $resolution.dig($res, 1)-32*$resolution.dig($res, 2) --> spur 0

        @y = $resolution.dig($res, 1)-32*$resolution.dig($res, 2)*(@spur+1)

    end

    def draw
        img = @bild[Gosu.milliseconds / 100 % @bild.size]
        img.draw(@x - img.width / 8.0, @y - img.height / 2.0, ZOrder::PLAYER, $scale, $scale) # (posX, posY, posZ, scale_x, scale_y)
    end
end


# Gegner
class Enemy
    def initialize
        @posX = $resolution.dig($res, 0) # float
        @spur = rand(3)
        @posY = $resolution.dig($res, 1)-32*$resolution.dig($res, 2)*(@spur+1)

        @bild = Gosu::Image.load_tiles("media/auto-2.png", 32, 32, :retro => true)

        anzahlVerschAutos = @bild.size % 32
        welchesBild = rand(anzahlVerschAutos)

        @img = @bild[welchesBild]
        @move_factor = 2
        @posZ = ZOrder::GEGNER
    end

    def x
        @posX
    end

    def spur
        @spur
    end

    def draw
        
        @posX -= @move_factor
        @img.draw(@posX, @posY, @posZ, $scale, $scale) # (posX, posY, posZ, scale_x, scale_y)
    end

end


class Star

    def initialize(animation)
        @animation = animation
        @color = Gosu::Color::BLACK.dup
        @color.red = rand(256-40) + 40
        @color.green = rand(256-40) + 40
        @color.blue = rand(256-40) + 40

        @move_factor = 2
        @posX = $resolution.dig($res, 0) # float
        @spur = rand(3)
        @posY = $resolution.dig($res, 1)-32*$resolution.dig($res, 2)*(@spur+1)+7*$scale
    end

    def x
        @posX
    end

    def spur
        @spur
    end
    
    def draw

        @posX -= @move_factor
        img = @animation[Gosu.milliseconds / 100 % @animation.size]
        img.draw(@posX, @posY, ZOrder::POWERUPS, ($scale-1), ($scale-1), @color, :add) # (posX, posY, posZ, scale_x, scale_y)
    end
end