-- Player
-- Inherits from Entity
Player = Class{
	__includes = Entity,
	speed = 100,
	l_foot = true,
	sonar_timer = 0,			-- time since last pulse
	sonar_rate = 0.1,			-- min time between pulses
	walk_timer = 0,				
	walk_speed = 1/2.5,			-- steps per second
	size = 10,
	name = 'player',
	sonar_list = {},
	sonar_index = 1,
	sonar_list_max = 9,
	sonar_speed = 100,
	sonar_lifetime = 1.5,
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

	-- Preallocate all the sonar objects
	for i = 1, self.sonar_list_max do
		table.insert( self.sonar_list, Pulse(self.x, self.y, self.sonar_speed, 200, self.sonar_lifetime, 1, true) )
		self.sonar_list[i].color = {80,60,255}
		self.sonar_list[i]:destroy()
	end

	self.sonar_sounds = Audio.load('audio/player/sonar',{
		'Sonar_Player_01.wav',
		'Sonar_Player_02.wav',
		'Sonar_Player_03.wav'})

	for i = 1, #self.sonar_sounds do
		self.sonar_sounds[i]:setVolume(0.7)
	end

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

	for i = 1, #self.l_foot_sounds do
		self.l_foot_sounds[i]:setVolume(0.7)
	end

	self.r_foot_sounds = Audio.load('audio/player/footsteps',{
		'Right_Foot_Player_Walk_01.wav',
		'Right_Foot_Player_Walk_02.wav',
		'Right_Foot_Player_Walk_03.wav',
		'Right_Foot_Player_Walk_04.wav',
		'Right_Foot_Player_Walk_05.wav'})

	for i = 1, #self.r_foot_sounds do
		self.r_foot_sounds[i]:setVolume(0.7)
	end
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

		for i = 1, #self.sonar_sounds do
			self.sonar_sounds[i]:setPosition(self.x * Audio.scale, self.y * Audio.scale, 0)
		end

		self:update_movement(dt)
	end

end

function Player:update_movement(dt)
	local axis_x, axis_y = 0, 0

	axis_x = controller_1:axis_x()
	axis_y = controller_1:axis_y()

	if axis_x ~= 0 or axis_y ~= 0 then
		self.body:setLinearVelocity( self.speed * axis_x, self.speed * axis_y )

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

		Audio.play_random(self.sonar_sounds)

		self.sonar_list[self.sonar_index]:destroy()
		self.sonar_list[self.sonar_index]:re_init(self.x, self.y, self.sonar_speed, self.sonar_lifetime)
		self.sonar_index = math.wrap(self.sonar_index+1, 1, self.sonar_list_max)
	end
end

function Player:draw()
	if self.alive then
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("fill", self.x, self.y, 10)
	end
end
