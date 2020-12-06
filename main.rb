require 'gosu'
require_relative 'menu'
require_relative 'player'
require_relative 'ambient'

module ZOrder
    BACKGROUND_SKY, BACKGROUND_MOUNTAIN, BACKGROUND_GREEN, STREET, POWERUPS, STARS, PLAYER, UI = *0..7
end



$resolution = [
    [600, 400, 2],
    [1280, 720, 4],
    [1920, 1080, 6],
]

$scale = 1
$res = 1
$anzahlHimmel = 8


class GameWindow < Gosu::Window
    def initialize

        @counter = 0

        # Auflösung
        super $resolution.dig($res, 0), $resolution.dig($res, 1)
        $scale = $resolution.dig($res, 2)
        
        # Headline
        self.caption = "Tutorial Game"

        # Objekte
        @background_image = Gosu::Image.new("media/space.png", :tileable => true)
        @player_bild = Gosu::Image.load_tiles("media/car.png", 32, 32, :retro => true)
        
        @player = Player.new(@player_bild)
        @player.warp(32*($resolution.dig($res, 2)-1), $resolution.dig($res, 1)/2-32*$resolution.dig($res, 2))

        #@star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
        #@stars = Array.new


        # Menu stuff

        @inMenu = true #bool für menu, startet ins menu
        self.switchToMenu

        @font = Gosu::Font.new(16*($scale-1), name: "media/pixelart.ttf")
        puts @font.name
        
        @menu_system = MenuSystem.new(self) # funktioniert autark

        @himmelOben = Array.new
        @himmelUnten = Array.new

        @ambientGreen = Array.new

        @button_last_state = Array.new

        
    end

    def switchToMenu
        @inMenu = true
        @music = Gosu::Song.new("media/hauptmenu.ogg")
        @music.play(true)
    end

    def switchToGame
        @music.stop
        @inMenu = false
        #@music = Gosu::Song.new("media/hauptmenu.ogg") # neuer Song
        #@music.play(true)

        #arrays initalisieren
        12.times do |i|
            @himmelOben.push(Sky.new(i*32*$scale, 0))  #Sky.new(x, y)
            @himmelUnten.push(Sky.new(i*32*$scale, 1))  #Sky.new(x, y)
        end

        5.times do |i|
            @ambientGreen.push(Green.new(i*64*$scale, 1))
        end

    end

    def update

        if @inMenu == false
            # spiel läuft


            # himmel # darf sich nur alle 4 Ticks bewegen,Hintergrund alle 2 Ticks ==> Himmel jeden Tick -1, Hintergrund -2, Straße -4

            if @counter % (32*$scale) == 0 #wenn 32px * scale vergangen, letzes löschen und neues erzeugen

                @himmelOben.push(Sky.new($resolution.dig($res, 0), 0))  #Sky.new(x, y)
                @himmelUnten.push(Sky.new($resolution.dig($res, 0), 1))  #Sky.new(x, y)

                @ambientGreen.push(Green.new($resolution.dig($res, 0), 1))

                if @himmelOben.first.get_x < -32*$scale
                    @himmelOben.shift
                    @himmelUnten.shift
                    @ambientGreen.shift
                end
            end

            #if rand(100) < 4 and @stars.size < 25
            #   @stars.push(Star.new(@star_anim))
            #end

            @player.move
        end

        
           #@player.collect_stars(@stars)
    end

    def draw
        @counter += 1
        # ...
        if @inMenu == true
            @menu_system.draw
        
        else
            #@background_image.draw(0, 0, ZOrder::BACKGROUND)
            @player.draw


            # himmel
            @himmelOben.each { |element| element.draw }
            @himmelUnten.each { |element| element.draw }
            @ambientGreen.each { |element| element.draw }


            #@font.draw_text("Punkte: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
            @font.draw_text("FPS: #{Gosu::fps()}", 150, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        end
    end

    def button_down(id)
        if @inMenu == true
            case id
            when Gosu::KB_ESCAPE
                close

            when Gosu::KB_RETURN
                @menu_system.select

            when Gosu::KB_DOWN
                @menu_system.next_element

            when Gosu::KB_UP
                @menu_system.last_element

            else
                super #für alt + enter

            end
        else
            case id
            when Gosu::KB_ESCAPE
                switchToMenu

            when Gosu::KB_DOWN
                @player.go_down

            when Gosu::KB_UP
                @player.go_up

            else
                super #für alt + enter

            end
        end
    end
end



GameWindow.new.show