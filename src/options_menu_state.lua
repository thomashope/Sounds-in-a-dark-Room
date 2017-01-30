options_menu_state = MenuState()

function options_menu_state:init()
	self.items = {'fullscreen', 'vsync', 'back to main menu'}
	self:get_window_mode()
end

function options_menu_state:enter()
	self:get_window_mode()
end

function options_menu_state:draw()
    love.graphics.setBackgroundColor(self.bg)
    love.graphics.print("Options...", 20, 20)

    love.graphics.setColor(255,255,255)
    for i = 1, #self.items do
    	local string = self.items[i]

    	if string == 'fullscreen' then
    		if self.window_mode.fullscreen then string = string..': [ON] off' else string = string..': on [OFF]' end
		elseif string == 'vsync' then
    		if self.window_mode.vsync then string = string..': [ON] off' else string = string..': on [OFF]' end
		end

    	if i == self.index then string = "> "..string end

    	love.graphics.print(string, 20, 60 + 20 * i)
    end
end

options_menu_state['fullscreen'] = function(self, keycode, scancode, isrepeat)
	if scancode == 'space' or scancode == 'return' then
		if not self.window_mode.fullscreen then
			love.window.setMode( love.graphics.getWidth(), love.graphics.getHeight(), {fullscreen=true} )
		else
			love.window.setMode( 800, 600, {fullscreen=false} )
		end
		self:get_window_mode()
	end
end

options_menu_state['vsync'] = function(self, keycode, scancode, isrepeat)
	if scancode == 'space' or scancode == 'return' then
		if not self.window_mode.vsync then
			love.window.setMode( love.graphics.getWidth(), love.graphics.getHeight(), {vsync=true, fullscreen=self.window_mode.fullscreen} )
		else
			love.window.setMode( love.graphics.getWidth(), love.graphics.getHeight(), {vsync=false, fullscreen=self.window_mode.fullscreen} )
		end
		self:get_window_mode()
	end
end

options_menu_state['back to main menu'] = function(self, keycode, scancode, isrepeat)
	if scancode == 'space' or scancode == 'return' then
		Gamestate.switch(main_menu_state)
	end
end

function options_menu_state:get_window_mode()
	local x, y = 0, 0
	x, y, self.window_mode = love.window.getMode()
end