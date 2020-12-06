require 'gosu'

class AmbientObject
    def initialize
        @posX # wert ist breite der Auflösung, mit jedem draw durchgang bewegt es sich um 1 nach links
        @posY 
        @bild
        @img
    end

    def get_x
        @posX
    end

    def draw

    end
end



class Sky < AmbientObject
    def initialize(x,y)
        @posX = x
        @posY = y*32*$scale

        @bild = Gosu::Image.load_tiles("media/sky.png", 32, 32, :retro => true)
        anzahlHimmel = @bild.size % 32
        welchesBild = rand(anzahlHimmel)
        @img = @bild[welchesBild]
    end

    def draw
        @posX -= 1
        @img.draw(@posX, @posY, ZOrder::BACKGROUND_SKY, $scale, $scale) # (posX, posY, posZ, scale_x, scale_y)
    end
end

class Green < AmbientObject
    def initialize(x,y)
        @posX = x
        @posY = y*16*$scale

        @bild = Gosu::Image.load_tiles("media/ambient.png", 64, 64, :retro => true)
        anzahlAmbient = @bild.size % 64
        welchesBild = rand(anzahlAmbient)
        @img = @bild[welchesBild]
    end

    def draw
        @posX -= 2
        @img.draw(@posX, @posY, ZOrder::BACKGROUND_SKY, $scale, $scale) # (posX, posY, posZ, scale_x, scale_y)
    end
end