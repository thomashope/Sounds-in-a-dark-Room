main_menu_state = MenuState()

function main_menu_state:init()
	self.items = {'play', 'options', 'credits', 'quit'}
    self.credits_string =
[[Originally created for the GGJ2017

Concept/Programming: Tom
@HopeThomasj

Audio: Chris
linkedin.com/in/christopher-quinn-sound

More levels by Bogdan, Sam A. and Sam C.

And thanks to Dundee Makerspace for the awesome jam site!]]
end

function main_menu_state:draw()
    love.graphics.setBackgroundColor(self.bg)
    love.graphics.print("Sounds in a Dark Room", 20, 20, 0, 3, 3)

    love.graphics.setColor(255,255,255)
    for i = 1, #self.items do
    	local string = self.items[i]
    	if i == self.index then string = "> "..string end
    	love.graphics.print(string, 20, 80 + 30 * i)
    end

    if self.items[self.index] == 'credits' or self.index ==3 then
        love.graphics.print(main_menu_state.credits_string, 20, 280)
    end
end

main_menu_state['play'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		Gamestate.switch(level_select_state)
	end
end

main_menu_state['options'] = function( self, scancode )
    if scancode == 'space' or controller_1:button_pressed_a() then
        Gamestate.switch(options_menu_state)
    end
end

main_menu_state['credits'] = function( self, scancode )
end

main_menu_state['quit'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
        love.event.quit()
    end
end