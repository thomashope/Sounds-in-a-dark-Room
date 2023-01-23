credits_screen_state = State()

function credits_screen_state:init()
    self.credits_string =
[[Originally created for the GGJ2017

Design & Programming

  Thomas Hope
  @thope_xyz


Audio

  Christopher Quinn
  linkedin.com/in/christopher-quinn-sound

More levels by Bogdan, Sam A. and Sam C.

Thanks to Dundee Makerspace for the awesome jam site!]]
end

function credits_screen_state:update()
	if controller_1:button_pressed_any() then
		Gamestate.switch(main_menu_state)
	end
end

function credits_screen_state:draw()
	love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.setColor(1,1,1)
	love.graphics.print(self.credits_string, 20, 20)
end

function credits_screen_state:keypressed( keycode, scancode, isrepeat )
	if scancode == 'space' then
		Gamestate.switch(main_menu_state)
	end
end