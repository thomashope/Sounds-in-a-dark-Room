playing_state = State()

function playing_state:init()
	self.bg = {100, 100, 100}
end

function playing_state:enter()
	Level.load("level4.png")
end

function playing_state:update(dt)
	Pulse:update_all(dt)
	Sonar:update_all(dt)
	Zombie:update_all(dt)

	player:update(dt)
end

function playing_state:draw()
	camera:attach()

	love.graphics.setBackgroundColor(self.bg)

    Lava:draw_all()
    Pulse:draw_all()
    Sonar:draw_all()
    Wall:draw_all()
    Zombie:draw_all()

    player:draw()

    camera:detach()
end

function playing_state:keypressed( keycode, scancode, isrepeat )
	if scancode == "space" then
		player:use_sonar()
	end
end