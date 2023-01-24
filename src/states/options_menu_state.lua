options_menu_state = MenuState()

function options_menu_state:init()
	self.items = {'volume', 'fullscreen', 'vsync', 'back to main menu'}
	self:get_window_mode()
	self.test_sound = love.audio.newSource('res/audio/player/sonar/Sonar_Player_01.wav', 'static')
end

function options_menu_state:enter()
	self:get_window_mode()
	self.index = 1
end

function options_menu_state:draw()
    love.graphics.setBackgroundColor(self.bg)
    love.graphics.print("Options", Fonts.title, 20, 20)

    love.graphics.setColor(255,255,255)
    for i = 1, #self.items do
    	local string = self.items[i]

    	if string == 'volume' then
    		string = string..': '..string.format('%d%%', love.audio.getVolume()*100)
    	elseif string == 'fullscreen' then
    		if self.window_mode.fullscreen then string = string..': [ON] off' else string = string..': on [OFF]' end
		elseif string == 'vsync' then
    		if self.window_mode.vsync then string = string..': [ON] off' else string = string..': on [OFF]' end
		end

		-- prepend a '>' to the selected item
    	if i == self.index then string = "> "..string end

    	love.graphics.print(string, 20, 80 + 30 * i)
    end
end

options_menu_state['volume'] = function( self, scancode )
	if scancode == 'left' or controller_1:button_pressed_left() then
		love.audio.setVolume( math.max(love.audio.getVolume() - 0.05, 0) )
	elseif scancode == 'right' or controller_1:button_pressed_right() then
		love.audio.setVolume( math.min(love.audio.getVolume() + 0.05, 1) )
	end

	Audio.play_random( player.sonar_sounds )
end

options_menu_state['fullscreen'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		if not self.window_mode.fullscreen then
			love.window.setMode( love.graphics.getWidth(), love.graphics.getHeight(), {fullscreen=true} )
		else
			love.window.setMode( 800, 600, {fullscreen=false} )
		end
		self:get_window_mode()
	end
end

options_menu_state['vsync'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		if not self.window_mode.vsync then
			love.window.setMode( love.graphics.getWidth(), love.graphics.getHeight(), {vsync=true, fullscreen=self.window_mode.fullscreen} )
		else
			love.window.setMode( love.graphics.getWidth(), love.graphics.getHeight(), {vsync=false, fullscreen=self.window_mode.fullscreen} )
		end
		self:get_window_mode()
	end
end

options_menu_state['back to main menu'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		Gamestate.switch(main_menu_state)
	end
end

function options_menu_state:get_window_mode()
	local x, y = 0, 0
	x, y, self.window_mode = love.window.getMode()
end