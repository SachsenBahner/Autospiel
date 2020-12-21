require 'gosu'
require_relative 'menu'
require_relative 'player'
require_relative 'ambient'

module ZOrder
    BACKGROUND_SKY, BACKGROUND_MOUNTAIN, BACKGROUND_GREEN, STREET, POWERUPS, GEGNER, PLAYER, UI = *0..7
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
        
        @music = Gosu::Song.new("media/hauptmenu-loop.ogg")

        # Headline
        self.caption = "Autospiel"

        # Objekte
        @background_image = Gosu::Image.new("media/space.png", :tileable => true)
        @player_bild = Gosu::Image.load_tiles("media/car.png", 32, 32, :retro => true)
        
        @player = Player.new(self, @player_bild)
        @player.warp(32*($resolution.dig($res, 2)-1), $resolution.dig($res, 1)/2-32*$resolution.dig($res, 2))


        # Menu stuff

        @inMenu = true #bool für menu, startet ins menu
        self.switchToMenu

        @font = Gosu::Font.new(16*($scale-1), name: "media/pixelart.ttf")
        puts @font.name
        
        @menu_system = MenuSystem.new(self) # funktioniert autark

        @himmelOben = Array.new
        @himmelUnten = Array.new

        @ambientGreen = Array.new
        @berge = Array.new

        @button_last_state = Array.new

        @gegner = Array.new

        @stars = Array.new
        @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25, :retro => true)
        
    end

    def switchToMenu
        @inMenu = true
        @music.stop
        @music = Gosu::Song.new("media/hauptmenu-loop.ogg")
        @music.play(true)
    end

    def switchToGame
        @himmelOben.clear()
        @himmelUnten.clear()
        @ambientGreen.clear()
        @berge.clear()
        @gegner.clear()
        @stars.clear()

        @music.stop
        @inMenu = false
        @music = Gosu::Song.new("media/ingame.ogg") # neuer Song
        @music.play(true)

        #arrays initalisieren
        12.times do |i|
            @himmelOben.push(Sky.new(i*32*$scale, 0))  #Sky.new(x, y)
            @himmelUnten.push(Sky.new(i*32*$scale, 1))  #Sky.new(x, y)
        end

        6.times do |i|
            @ambientGreen.push(Green.new(i*64*$scale, 1))
            @berge.push(Berg.new(i*64*$scale, 1))
        end

        @gegner.push(Enemy.new)
        @stars.push(Star.new(@star_anim))

    end

    def update

        if @inMenu == false
            # spiel läuft


            # himmel # darf sich nur alle 4 Ticks bewegen,Hintergrund alle 2 Ticks ==> Himmel jeden Tick -1, Hintergrund -2, Straße -4

            if @counter % (32*$scale) == 0 #wenn 32px * scale vergangen, letzes löschen und neues erzeugen

                @himmelOben.push(Sky.new($resolution.dig($res, 0), 0))  #Sky.new(x, y)
                @himmelUnten.push(Sky.new($resolution.dig($res, 0), 1))  #Sky.new(x, y)

                @ambientGreen.push(Green.new($resolution.dig($res, 0), 1))
                @berge.push(Berg.new($resolution.dig($res, 0), 1))
                @stars.push(Star.new(@star_anim))

                

                if @himmelOben.first.get_x < -32*$scale
                    @himmelOben.shift
                    @himmelUnten.shift
                    @ambientGreen.shift
                    @berge.shift
                end

                if @stars.size >= 10
                    @stars.shift
                end
            end
            if @counter % (64*$scale) == 0
                @gegner.push(Enemy.new)

                if @gegner.size == 5
                    @gegner.shift
                end
            end

            @player.move
            @player.check_collision(@gegner)
            @player.check_stars(@stars)
        end
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
            @berge.each { |element| element.draw }
            @gegner.each { |element| element.draw }
            @stars.each { |element| element.draw }


            #@font.draw_text("Punkte: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
            #@font.draw_text("FPS: #{Gosu::fps()}", 150, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
            
            @font.draw_text("Punkte: #{@player.score}", 150, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
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
                switchToMen


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