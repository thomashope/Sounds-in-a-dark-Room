pause_menu_state = MenuState()

function pause_menu_state:init()
	self.bg = {0, 0, 0, 100}
	self.title = ''
	self.items = {'restart', 'switch level', 'quit to main menu'}
end

function pause_menu_state:enter(previous, condition)
	if condition == 'win' then
		self.title = 'YOU KILLED EVERYTHING\n'
	end
end

-- trigered when restart is highlighted
pause_menu_state['restart'] = function( self, keycode, scancode, isrepeat )
	if scancode == 'space' or scancode == 'return' then
		Level.restart()
		Gamestate.switch(playing_state)
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
		Gamestate.switch(main_menu_state)
	end
end

function pause_menu_state:draw()
	playing_state:draw()

	love.graphics.setColor(self.bg)
	love.graphics.rectangle('fill', 0, 0, window_width, window_height)

    love.graphics.setColor(255,255,255)
    -- Title at the top of the screen
    love.graphics.print(self.title, 20, 20, 0, 3, 3)

    -- display menu items
    for i = 1, #self.items do
    	local string = self.items[i]
    	if i == self.index then string = "> "..string end
    	love.graphics.print(string, 20, 60 + 20 * i)
    end

    -- Display time take
    if Level.won then
    	local time = string.format('Time: %.2fs', Level.finish_time - Level.start_time)

    	love.graphics.print(time, 20, 150)
    end
end

function pause_menu_state:keypressed( keycode, scancode, isrepeat )
	MenuState.keypressed( self, keycode, scancode, isrepeat )

	if scancode == 'escape' then
		Gamestate.switch(playing_state)
	end
end