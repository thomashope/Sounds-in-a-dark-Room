playing_state = State()

function playing_state:init()
	self.bg = {0, 0, 0}
	-- TODO: incorporate canvas into object
	-- TODO: resize canvas on window resize
	-- TODO: apply nice effects like bloom?
	self.pips = love.graphics.newCanvas(window_width, window_heigt)
end

function playing_state:enter()
	love.graphics.setBackgroundColor(self.bg)
end

function playing_state:update(dt)
	Pulse:update_all(dt)
	Sonar:update_all(dt)
	Wall:update_all(dt)
	Zombie:update_all(dt)
	Pip:update_all(dt)

	player:update(dt)
end

function playing_state:draw()
	camera:attach()

    Lava:draw_all()
    Sonar:draw_all()
    Wall:draw_all()
    Zombie:draw_all()

	camera:detach()

	love.graphics.setBlendMode('alpha')
    love.graphics.setCanvas(self.pips)
    love.graphics.setColor(0, 0, 0, 20)
    love.graphics.rectangle('fill', 0, 0, window_width, window_height)
    camera:attach()

    camera:lookAt(player.x, player.y)
	Pip:draw_all()
    Pulse:draw_all()

	camera:detach()

	love.graphics.setCanvas()
	love.graphics.setBlendMode('add')
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.pips, 0, 0)
	love.graphics.setBlendMode('alpha')

	camera:attach()
    camera:lookAt(player.x, player.y)
    player:draw()

    camera:detach()
end

function playing_state:keypressed( keycode, scancode, isrepeat )
	if scancode == 'space' then
		player:use_sonar()
	elseif scancode == 'escape' then
		Gamestate.push(pause_menu_state)
	end
end

function playing_state:focus( f )
	if not f then
		Gamestate.push(pause_menu_state)
	end
end
