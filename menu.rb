require 'gosu'

#aaray [-1] --> letztes lement
# methode? --> gibt bool zurück


class MenuSystem
    def initialize(window) # mit (array) kann man auch ganz einfach ein array übergeben
        @active_id = 0

        @menu_buttons = Array.new # maximal 6 buttons
        @menu_buttons.push(Button.new(1, 3))
        @menu_buttons.push(Button.new(2, 3)) # position, anzahl elemente
        @menu_buttons.push(Button.new(3, 3))
        @gameWindow = window

        @menu_buttons[0].set_active(true)

    end

    def next_element
        if @active_id < @menu_buttons.size-1
            @menu_buttons[@active_id].set_active(false)
            @active_id +=1
            @menu_buttons[@active_id].set_active(true)
        end
    end

    def last_element
        if @active_id > 0
            @menu_buttons[@active_id].set_active(false)
            @active_id -=1
            @menu_buttons[@active_id].set_active(true)
        end
    end

    def select
        @select_sound = Gosu::Sample.new("media/menu_select_sound.ogg")
        @select_sound.play

        case @active_id
        when 0
            #starte Spiel
            @gameWindow.switchToGame

        when 1
            #Optionen


        when 2
            #Credits


        else

        end

    end

    def draw
        @menu_buttons.each { |button| button.draw }
    end
end




class Button
    def initialize(y_position, anzahlElemente)
        # ...
        @active = false

        @yVersatz = $resolution.dig($res, 1) / (anzahlElemente+1)

        @posY = @yVersatz * y_position - 16*$scale
        @posX = $resolution.dig($res, 0)/4

        @menu_switch_sound = Gosu::Sample.new("media/menu_plopping.ogg")
        @button_bild = Gosu::Image.new("media/button.png", :retro => true)
        @button_bild_active = Gosu::Image.new("media/button-active.png", :retro => true)
    end

    def set_active(active)
        @active = active
        @menu_switch_sound.play
    end

    def get_active
        @active
    end

    def draw
        if @active == true
            #andere textur
            @button_bild_active.draw(@posX, @posY, ZOrder::UI, $scale, $scale)
        else
            #normal
            @button_bild.draw(@posX, @posY, ZOrder::UI, $scale, $scale)
        end
    end
end