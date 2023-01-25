-- Zombie
-- Created by the level
-- Inherits from Entity
Zombie = Class{
	__includes = Entity,
	size = 15,
	all = {},
	name = 'zombie',
	charging = false,
	charge_time = 0,
	most_recent_target = 0,	-- The spawn time of the latest thing the zombie was charging at
	footstep_time = 0,
	play_footstep = false,
	left_foot = true,
	step_time = 0,
	charge_sounds = {},
	l_foot_sounds = {},
	r_foot_sounds = {},
	death_sounds = {}
}

-- TODO: can I recycle the shape across all zombies?
--       Would have to modify the delte function to not affect the shape

-- Constructor
function Zombie:init(x, y)
	self.x, self.y = x, y

	self.body = love.physics.newBody( Physics.world, self.x, self.y, 'dynamic' )
	local shape = love.physics.newCircleShape( self.size )
	self.fixture = love.physics.newFixture( self.body, shape, 1 )
	self.fixture:setRestitution( 0 )
	self.fixture:setCategory(2)
	self.fixture:setUserData( self )
	self.body:setLinearDamping(0.4)

	self.charge_sounds = Audio.load('audio/zombie/notice',{
		'Zombie_Notice_01.wav',
		'Zombie_Notice_02.wav',
		'Zombie_Notice_03.wav'})

	self.l_foot_sounds = Audio.load('audio/zombie/footsteps',{
		'Left_Foot_Zombie_Walk_01.wav',
		'Left_Foot_Zombie_Walk_02.wav',
		'Left_Foot_Zombie_Walk_03.wav',
		'Left_Foot_Zombie_Walk_04.wav',
		'Left_Foot_Zombie_Walk_05.wav'})

	self.r_foot_sounds = Audio.load('audio/zombie/footsteps',{
		'Right_Foot_Zombie_Walk_01.wav',
		'Right_Foot_Zombie_Walk_02.wav',
		'Right_Foot_Zombie_Walk_03.wav',
		'Right_Foot_Zombie_Walk_04.wav',
		'Right_Foot_Zombie_Walk_05.wav'})

	self.death_sounds = Audio.load('audio/zombie/death',{
		'Zombie_Death_01.wav',
		'Zombie_Death_02.wav',
		'Zombie_Death_03.wav'})

	table.insert( Zombie.all, self )
end

function Zombie:charge(xtarget, ytarget, spawn_time)
	if spawn_time > self.most_recent_target then
		self.most_recent_target = spawn_time
		self.charging = true
		local xdir, ydir = xtarget - self.x, ytarget - self.y
		xdir, ydir = Vector.normalize(xdir, ydir)
		self.body:setLinearVelocity( Vector.mul(150 , xdir, ydir) )
		self.charge_time = 1

		Audio.play_random_at(self.charge_sounds, self.x, self.y)

		self.play_footstep = true
	end
end

function Zombie:delete()
	if self.alive then
		self.body:destroy()
		self.alive = false

		Audio.play_random_at(self.death_sounds, self.x, self.y)
	end
end

function Zombie:update(dt)
	self.x, self.y = self.body:getPosition()

	if self.charge_time > 0 then
		self.charge_time = self.charge_time - dt
		self.footstep_time = self.footstep_time + dt

		if self.footstep_time > 0.2 then
			self.footstep_time = 0
			self.play_footstep = true
		end

	elseif self.charge_time < 0 then
		self.charge_time = 0
		self.body:setLinearVelocity( Vector.mul(0.2, self.body:getLinearVelocity()))
		self.charging = false
		self.play_footstep = true
	end

	if not self.charging then
		self.step_time = self.step_time - dt

		if self.step_time < 0 then
			-- set a new random step time
			self.step_time = love.math.random()*4

			-- pick a random direction
			local xdir, ydir = Vector.rotate(love.math.random()*math.pi*2, 0, 1)
			xdir, ydir = Vector.mul(20, xdir, ydir)
			self.body:setLinearVelocity(xdir, ydir)

			self.play_footstep = true
		end
	end

	-- play a footstep sound
	if self.play_footstep then
		if self.left_foot then
			Audio.play_random_at(self.l_foot_sounds, self.x, self.y)
		else
			Audio.play_random_at(self.r_foot_sounds, self.x, self.y)
		end

		-- Create footstep pulse
		local p = Pulse(self.x, self.y, 150, 25, 0.2, {1,2})
		p.color = {0.4,1,0.4}
		p.name = 'zombie step'

		self.left_foot = not self.left_foot
		self.play_footstep = false
	end
end

function Zombie:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle('fill', self.x, self.y, self.size)
end

function Zombie:update_all(dt)
	-- Update all zombies, remove th eones that are dead
	local i = 1
	while i <= #self.all do
		if not self.all[i].alive then
			table.remove( self.all, i )
		else
			self.all[i]:update(dt)
			i = i + 1
		end
	end
end

function Zombie:draw_all()
	love.graphics.setColor(0, 0, 0)
	for i = 1, #self.all do
		love.graphics.circle('fill', self.all[i].x, self.all[i].y, self.all[i].size)
	end
end

function Zombie:clear_all()
	if #self.all > 0 then
		for i = 1, #self.all do
			self.all[i]:delete()
		end
		self.all = {}
	end
end
