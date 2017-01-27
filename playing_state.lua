playing_state = State()

function playing_state:init()

	self.bg = {100, 100, 100}

	Entity(100, 100)
	Pulse(150, 100, 0, 50, 1)
	Pulse(100, 150, 10, 50, 5)
	Pulse(150, 150, 20, 50, 10)
	Sonar(window_width/2, window_height/2)

	Wall(100, 100)
	Wall(100, 200)
	Wall(100, 300)
end

function playing_state:update(dt)
	player:update(dt)

	Pulse:update_all(dt)
	Sonar:update_all(dt)
end

function playing_state:draw()
	love.graphics.setBackgroundColor(self.bg)

    Pulse:draw_all()
    Sonar:draw_all()
    Wall:draw_all()

    love.graphics.print(#Pulse.all, 20, 200)
    love.graphics.print(#Sonar.all, 20, 220)

    player:draw()
end

function playing_state:keypressed( keycode, scancode, isrepeat )
	if scancode == "space" then
		player:use_sonar()
	end
end