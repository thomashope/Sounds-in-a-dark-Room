splash_screen_state = State()

function splash_screen_state:init()
	self.bg = {255, 255, 255}
end

function splash_screen_state:enter()
	Timer.tween(1.5, self.bg, {0,0,0}, 'in-out-quad')
	Timer.after(3, function() Gamestate.switch(main_menu_state) end)
end

function splash_screen_state:update(dt)
end

function splash_screen_state:draw()
	love.graphics.setBackgroundColor(self.bg)

	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("Sounds in a Dark Room", 0, window_height/3, window_width/4, "center", 0, 4)
end