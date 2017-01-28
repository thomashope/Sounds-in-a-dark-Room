-- Player
-- Inherits from Entity
Player = Class{
	__includes = Entity,
	speed = 200,
	input = 'keyboard',
	walk_timer = 0,
	walk_speed = 1/2.5,		-- steps per second
	size = 10,
	name = 'player'
}

-- Constructor
function Player:init(x, y)
	self.x, self.y = x, y

	self.body = love.physics.newBody( Physics.world, self.x, self.y, 'dynamic')
	self.shape = love.physics.newCircleShape( self.size )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setRestitution( 0 )
	self.fixture:setUserData( self )
end

function Player:delete()
	self.body:destroy()
	self.alive = false
end

function Player:update(dt)

	self.x = self.body:getX()
	self.y = self.body:getY()
	camera:lookAt( self.x, self.y )

	if self.alive then
		self:update_movement(dt)
	end
end

function Player:update_movement(dt)
	local x_axis, y_axis = 0, 0

	-- if self.input == 'keyboard' then
	if love.keyboard.isScancodeDown('up') then
		y_axis = -1
	elseif love.keyboard.isScancodeDown('down') then
		y_axis = 1
	end

	if love.keyboard.isScancodeDown('left') then
		x_axis = -1
	elseif love.keyboard.isScancodeDown('right') then
		x_axis = 1
	end

	if self.input ~= 'keyboard' then
		if self.input:isGamepad() then

			-- TODO: test this!!!

			if self.input:isGamepadDown('dpup') then
				y_axis = -1
			elseif self.input:isGamepadDown('dpup') then
				y_axis = 1
			end

			if self.input:isGamepadDown('dpleft') then
				x_axis = -1
			elseif self.input:isGamepadDown('dpright') then
				x_axis = 1
			end

			-- get input from the left stick
			if math.abs(self.input:getGamepadAxis('leftx')) > 0.2 then
				x_axis = self.input:getGamepadAxis('leftx')
			end
			if math.abs(self.input:getGamepadAxis('lefty')) > 0.2 then
				y_axis = self.input:getGamepadAxis('lefty')
			end

		else -- assume the input is either a joyostick or gamepad

			-- get input from the joystick 'dpad', here we assume the joystick is actually just an unrecognised gamepad
			if self.input:isDown(12) then
				y_axis = -1
			elseif self.input:isDown(13) then
				y_axis = 1
			end

			if self.input:isDown(14) then
				x_axis = -1
			elseif self.input:isDown(15) then
				x_axis = 1
			end

			-- get input from what we assume is the left stick
			if math.abs(self.input:getAxis(1)) > 0.2 then
				x_axis = self.input:getAxis(1)
			end
			if math.abs(self.input:getAxis(2)) > 0.2 then
				y_axis = self.input:getAxis(2)
			end
		end
	end

	if x_axis ~= 0 or y_axis ~= 0 then
		self.body:setLinearVelocity( self.speed * x_axis, self.speed * y_axis )

		self.walk_timer = self.walk_timer + dt
	else
		self.body:setLinearVelocity( 0, 0 )
		self.walk_timer = self.walk_speed
	end

	if self.walk_timer > self.walk_speed then
		Pulse(self.x, self.y, 0, 20, 1)
		self.walk_timer = 0
	end
end

function Player:set_position(x, y)
	self.body:setPosition(x, y)
end

function Player:use_sonar()
	Sonar(self.x, self.y)
end

function Player:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", self.x, self.y, 10)
end