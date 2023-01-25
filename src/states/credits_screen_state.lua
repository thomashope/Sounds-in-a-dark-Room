credits_screen_state = State()

local lg = love.graphics

function credits_screen_state:init()
end

function credits_screen_state:update()
	if controller_1:button_pressed_any() then
		Gamestate.switch(main_menu_state)
	end
end

function credits_screen_state:draw()
	love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.setColor(1,1,1)

	local x = window_width * 0.5
	local y = 70
	local space = 10
	local big_space = 80

	local heading_font = Fonts.title
	local name_font = Fonts.body

	local heading_font_size = heading_font:getHeight()
	local name_font_size = name_font:getHeight()

	lg.printf("Design & Programming", heading_font, 0, y, window_width, "center")
	y = y + heading_font_size + space
	lg.printf("Thomas Hope", name_font, 0, y, window_width, "center")
	y = y + big_space
	lg.printf("Audio", heading_font, 0, y, window_width, "center")
	y = y + heading_font_size + space
	lg.printf("Christopher Quinn", name_font, 0, y, window_width, "center")
	y = y + big_space
	lg.printf("Bonus Levels", heading_font, 0, y, window_width, "center")
	y = y + heading_font_size + space
	lg.printf("Bogdan H.", name_font, 0, y, window_width, "center")
	y = y + name_font_size + space
	lg.printf("Sam A.", name_font, 0, y, window_width, "center")
	y = y + name_font_size + space
	lg.printf("Sam C.", name_font, 0, y, window_width, "center")
end

function credits_screen_state:keypressed( keycode, scancode, isrepeat )
	if scancode == 'space' then
		Gamestate.switch(main_menu_state)
	end
end