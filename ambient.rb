require 'gosu'

class AmbientObject
    def initialize
        @posX # wert ist breite der Auflösung, mit jedem draw durchgang bewegt es sich um 1 nach links
        @posY 
        @bild
        @img
        @move_factor
        @posZ
    end

    def get_x
        @posX
    end

    def draw
        @posX -= @move_factor
        @img.draw(@posX, @posY, @posZ, $scale, $scale) # (posX, posY, posZ, scale_x, scale_y)
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

        @move_factor = 1
        @posZ = ZOrder::BACKGROUND_SKY
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
        @move_factor = 3
        @posZ = ZOrder::BACKGROUND_GREEN
    end
end

class Berg < AmbientObject
    def initialize(x,y)
        @posX = x
        @posY = y*16*$scale

        @bild = Gosu::Image.load_tiles("media/berge.png", 64, 64, :retro => true)
        anzahlAmbient = @bild.size % 64
        welchesBild = rand(anzahlAmbient)
        @img = @bild[welchesBild]
        @move_factor = 2
        @posZ = ZOrder::BACKGROUND_MOUNTAIN
    end
end