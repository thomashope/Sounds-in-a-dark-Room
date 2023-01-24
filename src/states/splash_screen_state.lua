splash_screen_state = State()

function splash_screen_state:init()
	self.bg = {1, 1, 1}
	self.done = false
end

function splash_screen_state:enter()
	Timer.tween(1.5, self.bg, {0,0,0}, 'in-out-quad')
	Timer.after(3, function() splash_screen_state:finish() end)
end

function splash_screen_state:finish()
	if not self.done then
		self.done = true
		Gamestate.switch(main_menu_state)
	end
end

function splash_screen_state:update(dt)
	if controller_1:button_pressed_any() or
		(controller_1.device ~= 'keyboard' and controller_1:button_down_a_keyboard()) then
		self:finish()
	end
end

function splash_screen_state:draw()
	love.graphics.setBackgroundColor(self.bg)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(
		"Sounds in a Dark Room",	-- text
		Fonts.splash_screen,		-- font
		0, 							-- x pos
		window_height/3, 			-- y pos
		window_width, 				-- wrap width
		"center") 					-- align
end