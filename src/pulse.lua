-- Pulse
-- Emitted by all things that make a noise
-- Inherits from Entity
Pulse = Class{
	__includes = Entity,
	lifetime = 1,
	color = {1,1,1},
	name = 'pulse',
	age = 0,
	pips = {},
	spawn_time = 0,
	preallocated = false,
	immidiate_instances = {}, -- Contains all instances of Pulse, Each subclass uses it's own table
	preallocated_instances = {}
}

local lg = love.graphics

-- A pulse has a location, around which it fires a bunch of particles 'pips'
-- The pulse can either be immidiate or preallocated
-- An immitiate pulse will be removed and garbage collected once it's lifetime expires
-- A preallocated pulse will have it's fixtures destroyed, but stay in the preallocated list
-- This allows someone else to call re_init on it and it can continue as normal

function Pulse:init(x, y, speed, count, lifetime, mask, preallocated)
	self.x, self.y = x, y
	self.pips = {}
	self.lifetime = lifetime
	self.spawn_time = love.timer.getTime()

	local shape = love.physics.newCircleShape(2)
	local xdir, ydir = Vector.rotate(love.math.random(), 0, 1)
	local incr = (math.pi*2)/count
	local mask = mask or 1

	for i = 1, count do
		local fixture = love.physics.newFixture(
			love.physics.newBody(Physics.world, x, y, 'dynamic'), shape, 0.01 )
		fixture:setRestitution(1)
		fixture:setUserData(self)
		fixture:setMask(mask)

		fixture:getBody():setLinearVelocity(xdir*speed, ydir*speed)
		xdir, ydir = Vector.rotate(incr, xdir, ydir)

		table.insert( self.pips, fixture )
	end

	if preallocated then
		table.insert( Pulse.preallocated_instances, self )
		self.preallocated = true
	else
		table.insert( Pulse.immidiate_instances, self )
	end

	return self
end

-- Destory all the fixtures but keep the table allocated
function Pulse:destroy()
	for i = 1, #self.pips do
		self.alive = false
		if not self.pips[i]:isDestroyed() then
			self.pips[i]:getBody():destroy();
			--self.pips[i]:destroy()
		end
	end
end

-- Use the currently allocated pips table and recreate them
function Pulse:re_init(x, y, speed, lifetime, mask)
	self.x, self.y = x, y
	self.lifetime = lifetime
	self.spawn_time = love.timer.getTime()
	self.age = 0
	self.alive = true

	local shape = love.physics.newCircleShape(2)
	local xdir, ydir = Vector.rotate(love.math.random(), 0, 1)
	local incr = (math.pi*2)/#self.pips
	local mask = mask or 1

	for i = 1, #self.pips do
		self.pips[i] = love.physics.newFixture(
			love.physics.newBody(Physics.world, x, y, 'dynamic'), shape, 0.01 )
		self.pips[i]:setRestitution(1)
		self.pips[i]:setUserData(self) -- 
		self.pips[i]:setMask(mask)
		self.pips[i]:getBody():setLinearVelocity(xdir*speed, ydir*speed)
		xdir, ydir = Vector.rotate(incr, xdir, ydir)
	end
end

-- Update an individual pulse
function Pulse:update(dt)

	if self.alive then
		self.age = self.age + dt
	
		if self.age > self.lifetime then
			self.alive = false
		end
	end
end

function Pulse:draw()
	
	-- build list of pip positions
	local positions = {}
	for i = 1, #self.pips do
		local x, y = self.pips[i]:getBody():getPosition()
		table.insert(positions, x)
		table.insert(positions, y)
	end

	-- duplicate the initial points so our line joins back on the start
	table.insert(positions, positions[1])
	table.insert(positions, positions[2])

	lg.setColor(self.color[1], self.color[2], self.color[3], 1.2*(1-(self.age / self.lifetime)) )
	lg.line(positions)
end

-- Update all pulses, remove the ones that are dead
function Pulse:update_all(dt)

	-- When an immidiate pulse dies, remove it from the table
	local i = 1
	while i <= #self.immidiate_instances do
		if self.immidiate_instances[i].alive then
			-- If it's alive, call update
			self.immidiate_instances[i]:update(dt)
			i = i + 1
		else
			self.immidiate_instances[i]:destroy()
			table.remove( self.immidiate_instances, i )
		end
	end

	-- When a preallocated pulse dies, destroy all its fixtures
	-- but leave it in the array
	for j = 1, #self.preallocated_instances do
		if self.preallocated_instances[j].alive then
			self.preallocated_instances[j]:update(dt)
		else
			self.preallocated_instances[j]:destroy()
		end
	end
end

function Pulse:draw_all()
	love.graphics.setPointSize(3)

	-- We assume that by this point update_all has already been called
	-- and all pulses in the immidiate list are alive
	for i = 1, #self.immidiate_instances do
		self.immidiate_instances[i]:draw()
	end

	-- In the preallocated list however there may be dead pulses
	-- waiting to be re_init()ed, so we have to check they are alive first
	for i = 1, #self.preallocated_instances do
		if self.preallocated_instances[i].alive then
			self.preallocated_instances[i]:draw()
		end
	end
end

function Pulse:clear_all()

	local bodies = Physics.world:getBodies()
	local fixtures = {}

	-- Create a list of all fixtures
	for i = 1, #bodies do
		for j = 1, #bodies[i]:getFixtures() do
			table.insert( fixtures, bodies[i]:getFixtures()[j] )
		end
	end

	-- Now iterate over all fixtures, checking it's name is pulse
	-- destroying every body the fixture is associated with
	for i = 1, #fixtures do
		if not fixtures[i]:isDestroyed() then
			if fixtures[i]:getUserData() and fixtures[i]:getUserData().name == 'pulse' then
				fixtures[i]:getBody():destroy()
			end
		end
	end

	-- Now clear the immidiate instances table
	self.immidiate_instances = {}

	-- An ensure all the preallocated instances are dead
	for i = 1, #self.preallocated_instances do
		self.preallocated_instances[i].alive = false
	end
end