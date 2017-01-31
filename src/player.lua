-- Player
-- Inherits from Entity
Player = Class{
	__includes = Entity,
	speed = 100,
	input = 'keyboard',
	l_foot = true,
	sonar_timer = 0,			-- time since last pulse
	sonar_rate = 0.1,			-- min time between pulses
	walk_timer = 0,
	walk_speed = 1/2.5,		-- steps per second
	size = 10,
	name = 'player',
	sonar_sounds = {},
	lava_death_sounds = {},
	zombie_death_sounds = {},
	l_foot_sounds = {},
	r_foot_sounds = {}
}

-- Constructor
function Player:init(x, y)
	self.x, self.y = x, y

	self.body = love.physics.newBody( Physics.world, self.x, self.y, 'dynamic')
	local shape = love.physics.newCircleShape( self.size )
	self.fixture = love.physics.newFixture( self.body, shape, 1 )
	self.fixture:setRestitution( 0 )
	self.fixture:setUserData( self )
	-- NOTE: players are in catagory 1
	--- use setMask(1) to make objects NOT collide with the player
	self.fixture:setCategory(1)

	self.sonar_sounds = Audio.load('audio/player/sonar',{
		'Sonar_Player_01.wav',
		'Sonar_Player_02.wav',
		'Sonar_Player_03.wav'})

	self.lava_death_sounds = Audio.load('audio/player/death',{
		'Player_Death_Lava.wav'})

	self.zombie_death_sounds = Audio.load('audio/player/death',{
		'Player_Death_Zombie_01.wav',
		'Player_Death_Zombie_02.wav',
		'Player_Death_Zombie_03.wav'})

	self.l_foot_sounds = Audio.load('audio/player/footsteps',{
		'Left_Foot_Player_Walk_01.wav',
		'Left_Foot_Player_Walk_02.wav',
		'Left_Foot_Player_Walk_03.wav',
		'Left_Foot_Player_Walk_04.wav',
		'Left_Foot_Player_Walk_05.wav'})

	self.r_foot_sounds = Audio.load('audio/player/footsteps',{
		'Right_Foot_Player_Walk_01.wav',
		'Right_Foot_Player_Walk_02.wav',
		'Right_Foot_Player_Walk_03.wav',
		'Right_Foot_Player_Walk_04.wav',
		'Right_Foot_Player_Walk_05.wav'})
end

function Player:spawn(x, y)
	if not self.alive then
		self.alive = true
		self.body = love.physics.newBody( Physics.world, self.x, self.y, 'dynamic')
		local shape = love.physics.newCircleShape( self.size )
		self.fixture = love.physics.newFixture( self.body, shape, 1 )
		self.fixture:setRestitution( 0 )
		self.fixture:setUserData( self )
		-- NOTE: players are in catagory 1
		--- use setMask(1) to make objects NOT collide with the player
		self.fixture:setCategory(1)
		print('respawned the playe')
	end

	self:set_position(x, y)
end

function Player:set_position(x, y)
	self.body:setPosition(x, y)
end

function Player:delete()
	self.body:destroy()
	self.alive = false
end

function Player:die(killer)
	self:delete()
	if killer == 'lava' then
		Audio.play_random_at(self.lava_death_sounds, self.x, self.y)
	else -- assume killer is zombie
		Audio.play_random_at(self.zombie_death_sounds, self.x, self.y)
	end
end

function Player:update(dt)
	self.sonar_timer = self.sonar_timer + dt
	
	if self.alive then
		self.x, self.y = self.body:getPosition()
		camera:lookAt( self.x, self.y )
		Audio.set_listener( self.x, self.y )

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
		Pulse(self.x, self.y, 120, 60, 0.25)
		self.walk_timer = 0
		if self.l_foot then
			Audio.play_random_at(self.l_foot_sounds, self.x, self.y)
		else
			Audio.play_random_at(self.r_foot_sounds, self.x, self.y)
		end
		self.l_foot = not self.l_foot
	end
end

function Player:use_sonar()
	if self.sonar_timer > self.sonar_rate and self.alive then
		self.sonar_timer = 0

		Audio.play_random_at(self.sonar_sounds, self.x, self.y)

		local p = Pulse(self.x, self.y, 100, 200, 1.5)
		p.color = {0, 255, 100}
	end
end

function Player:draw()
	if self.alive then
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("fill", self.x, self.y, 10)
	end
end