playing_state = State()

-- TODO: make not incredibly shitty blur shader!!
--	See github/vrld/shine for examples of working blur shaders
-- TODO: fix smudging effect on screen...

function playing_state:init()
	self.bg = {0, 0, 0}
	-- TODO: incorporate canvas into object
	-- TODO: apply nice effects like bloom?
	self.pips_canvas = love.graphics.newCanvas(window_width, window_height)

    local pixelcode = [[
    	uniform vec2 texture_size;

        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
        	vec2 px_to_uv = vec2(1, 1) / texture_size;
            vec4 texcolor = Texel(texture, texture_coords);
            texcolor += Texel(texture, texture_coords + vec2( 1.4,  0) * px_to_uv);
            texcolor += Texel(texture, texture_coords + vec2(-1.4,  0) * px_to_uv);
            texcolor += Texel(texture, texture_coords + vec2( 0, -1.4) * px_to_uv);
            texcolor += Texel(texture, texture_coords + vec2( 0,  1.4) * px_to_uv);
            texcolor *= 0.2;
            return texcolor * color * vec4(1,1,1,0.9);
        }
    ]]
	self.blur_shader = love.graphics.newShader( pixelcode )
end

function playing_state:enter()
	love.graphics.setBackgroundColor(self.bg)

	-- Clear the canvas
	love.graphics.setCanvas(self.pips_canvas)
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

	self:update_canvas_size()
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

function playing_state:update_canvas_size()
	if window_width ~= self.pips_canvas:getWidth() or window_height ~= self.pips_canvas:getHeight() then
		self.pips_canvas = love.graphics.newCanvas(window_width, window_height)
	end
end

function playing_state:draw()
	camera:attach()

	Lava:draw_all()
	Wall:draw_all()

	camera:detach()

	love.graphics.setBlendMode('alpha')
	love.graphics.setCanvas(self.pips_canvas)
	love.graphics.setColor(0, 0, 0, 0.51)
	love.graphics.rectangle('fill', 0, 0, self.pips_canvas:getWidth(), self.pips_canvas:getHeight())

	camera:attach()

	camera:lookAt(player.x, player.y)
	Pulse:draw_all()

	camera:detach()

	love.graphics.setCanvas()
	love.graphics.setBlendMode('add')
	love.graphics.setColor(1, 1, 1)
	self.blur_shader:send('texture_size', { self.pips_canvas:getWidth(), self.pips_canvas:getHeight() })
	love.graphics.setShader(self.blur_shader)
	love.graphics.draw(self.pips_canvas, 0, 0)
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