splash_screen_state = State()

function splash_screen_state:init()
	self.bg = {255, 255, 255}
	self.done = false
end

function splash_screen_state:enter()
	Timer.tween(1.5, self.bg, {0,0,0}, 'in-out-quad')
	Timer.after(3, function() splash_screen_state:switch() end)
end

function splash_screen_state:switch()
	if not self.done then
		self.done = true
		Gamestate.switch(main_menu_state)
	end
end

function splash_screen_state:update(dt)
end

function splash_screen_state:draw()
	love.graphics.setBackgroundColor(self.bg)

	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("Sounds in a Dark Room", 0, window_height/3, window_width/4, "center", 0, 4)
end

function splash_screen_state:keypressed( keycode, scancode, isrepeat )
	if scancode == 'space' then
		self:switch()
	end
end