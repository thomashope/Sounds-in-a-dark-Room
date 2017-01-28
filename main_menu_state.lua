main_menu_state = MenuState()

function main_menu_state:init()
	self.items = {'play', 'options', 'quit'}
end

function main_menu_state:update(dt)
end

function main_menu_state:draw()
    love.graphics.setBackgroundColor(self.bg)
    love.graphics.print("Main menu...", 20, 20)

    love.graphics.setColor(255,255,255)
    for i = 1, #self.items do
    	local string = self.items[i]
    	if i == self.index then string = "> "..string end
    	love.graphics.print(string, 20, 50 + 20 * i)
    end
end

main_menu_state['play'] = function( self, keycode, scancode, isrepeat )
	if scancode == 'space' or scancode == 'return' then
		Gamestate.switch(level_select_state)
	end
end

main_menu_state['options'] = function( self, keycode, scancode, isrepeat )
end

main_menu_state['quit'] = function( self, keycode, scancode, isrepeat )
	if scancode == 'space' or scancode == 'return' then
        love.event.quit()
    end
end