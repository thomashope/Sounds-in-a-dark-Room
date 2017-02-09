controller_prompt_state = {}

function controller_prompt_state:update()
	if controller_1:button_pressed_any() then
		Gamestate.pop()
	end
end

function controller_prompt_state:draw()

	playing_state:draw()
	love.graphics.setColor(0,0,0,100)
	love.graphics.rectangle('fill', 0, 0, window_width, window_height)

	love.graphics.setColor(255,255,255)
	love.graphics.printf("There is a controller connected, use that!", 0, 40, window_width/2, 'center', 0, 2, 2)
end