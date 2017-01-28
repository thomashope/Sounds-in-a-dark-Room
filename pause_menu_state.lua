pause_menu_state = MenuState()

function pause_menu_state:init()
	self.bg = {0, 0, 0, 100}

	self.items = {'restart', 'switch level', 'quit to main menu'}
end

-- trigered when restart is highlighted
pause_menu_state['restart'] = function( self, keycode, scancode, isrepeat )
	if scancode == 'space' or scancode == 'return' then
		Level.restart()
		Gamestate.pop()
	end
end

-- triggered when switch level is highlighted
pause_menu_state['switch level'] = function( self, keycode, scancode, isrepeat )
	if scancode == 'space' or scancode == 'return' then
		print('switch level')
		Gamestate.switch(level_select_state)
	end
end

-- triggered when quit to main menu is highlighted
pause_menu_state['quit to main menu'] = function( self, keycode, scancode, isrepeat )
	if scancode == 'space' or scancode == 'return' then
		Gamestate.pop()
		Gamestate.switch(main_menu_state)
	end
end

function pause_menu_state:draw()
	playing_state:draw()

	love.graphics.setColor(self.bg)
	love.graphics.rectangle('fill', 0, 0, window_width, window_height)

    love.graphics.setColor(255,255,255)
    for i = 1, #self.items do
    	local string = self.items[i]
    	if i == self.index then string = "> "..string end
    	love.graphics.print(string, 20, 50 + 20 * i)
    end
end

function pause_menu_state:keypressed( keycode, scancode, isrepeat )
	MenuState.keypressed( self, keycode, scancode, isrepeat )

	if scancode == 'escape' then
		Gamestate.pop()
	end
end