playing_state = State()

-- TODO: make not incredibly shitty blur shader!!
--	See github/vrld/shine for examples of working blur shaders
-- TODO: fix smudging effect on screen...

function playing_state:init()
	self.bg = {0, 0, 0}
	-- TODO: incorporate canvas into object
	-- TODO: apply nice effects like bloom?
	self.pips = love.graphics.newCanvas(window_width, window_height)

    local pixelcode = [[
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
            vec4 texcolor = Texel(texture, texture_coords);
            texcolor += Texel(texture, texture_coords + vec2(0.002, 0));
            texcolor += Texel(texture, texture_coords + vec2(-0.002, 0));
            texcolor += Texel(texture, texture_coords + vec2(0, -0.002));
            texcolor += Texel(texture, texture_coords + vec2(0, 0.002));
            texcolor *= 0.2;
            return texcolor * color * vec4(1,1,1,0.9);
        }
    ]]
	self.blur_shader = love.graphics.newShader( pixelcode )
end

function playing_state:enter()
	love.graphics.setBackgroundColor(self.bg)

	-- Clear the canvas
	love.graphics.setCanvas(self.pips)
	love.graphics.clear(0, 0, 0, 1)
	love.graphics.setCanvas()
end

function playing_state:update(dt)
	if controller_1.device ~= 'keyboard' and controller_1:button_pressed_start() then
		Gamestate.switch(pause_menu_state, 'paused')
	elseif controller_1:button_pressed_a() then
		player:use_sonar()
	end

	Physics.update(dt)

	Pulse:update_all(dt)
	Wall:update_all(dt)
	Zombie:update_all(dt)

	player:update(dt)

	if #Zombie.all == 0 then
		Level.finish_time = love.timer.getTime()
		Level.won = true
		Gamestate.push(pause_menu_state)
	end
end

function playing_state:draw()
	camera:attach()

	Lava:draw_all()
	Wall:draw_all()

	camera:detach()


	love.graphics.setBlendMode('alpha')
	love.graphics.setCanvas(self.pips)
	love.graphics.setColor(0.1/255, 0.1/255, 0.1/255, 20/255)
	love.graphics.rectangle('fill', 0, 0, self.pips:getWidth(), self.pips:getHeight())

	camera:attach()

	camera:lookAt(player.x, player.y)
	Pulse:draw_all()

	-- love.graphics.setCanvas()

	camera:detach()

	love.graphics.setCanvas()
	love.graphics.setBlendMode('add')
	love.graphics.setColor(1, 1, 1)
	love.graphics.setShader(self.blur_shader)
	love.graphics.draw(self.pips, 0, 0)
	love.graphics.setBlendMode('alpha')
	love.graphics.setShader()

	camera:attach()

	camera:lookAt(player.x, player.y)
	player:draw()
	Zombie:draw_all()

	camera:detach()
end

function playing_state:keypressed( keycode, scancode, isrepeat )
	if scancode == 'escape' then
		Gamestate.switch(pause_menu_state, 'paused')
	end

	if controller_1.device ~= 'keyboard' and (
		scancode == 'left' or
		scancode == 'right' or
		scancode == 'up' or
		scancode == 'down' or
		scancode == 'space') then
			Gamestate.push(controller_prompt_state)
	end
end

function playing_state:focus( f )
	if not f then
		Gamestate.switch(pause_menu_state, 'paused')
	end
end