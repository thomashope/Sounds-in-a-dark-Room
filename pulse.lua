-- Pulse
-- Emitted by all things that make a noise
-- Inherits from Entity
Pulse = Class{
	__includes = Entity,
	start_radius = 0,
	end_radius = 10,
	lifetime = 1,
	age = 0,
	all = {}				-- Contains all instances of Pulse, Each subclass uses it's own table
}

-- Constructor
function Pulse:init(x, y, start_radius, end_radius, lifetime)
	self.x, self.y = x, y
	self.start_radius = start_radius
	self.end_radius = end_radius
	self.lifetime = lifetime

	table.insert( Pulse.all, self )
end

function Pulse:update(dt)
	if self.alive then
		self.age = self.age + dt
		if self.age > self.lifetime then
			self.alive = false
		end
	end
end

function Pulse:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle('line', self.x, self.y, self.start_radius + (self.end_radius - self.start_radius) * (self.age/self.lifetime) )
end

function Pulse:update_all(dt)
	-- Update all pulses, remove the ones that are dead
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

function Pulse:draw_all()
	love.graphics.setLineWidth(2)
	for i = 1, #self.all do
		love.graphics.setColor(255, 255, 255, 200 * (1-(self.all[i].age/self.all[i].lifetime)) + 30 )
		love.graphics.circle('line', self.all[i].x, self.all[i].y, self.all[i].start_radius + (self.all[i].end_radius - self.all[i].start_radius) * (self.all[i].age/self.all[i].lifetime) + 1 )
		love.graphics.circle('fill', self.all[i].x, self.all[i].y, self.all[i].start_radius + (self.all[i].end_radius - self.all[i].start_radius) * (self.all[i].age/self.all[i].lifetime) + 1 )
	end
end

function Pulse:clear_all()
	self.all = {}
end

-- Pip
Pip = Class{
	__includes = Entity,
	name = 'pip',
	age = 0,
	lifetime = 2,
	health = 2,
	all = {},
	queue = {}
}

function Pip:init(x, y, xdir, ydir, age, health)
	self.body = love.physics.newBody( Physics.world, x, y, 'dynamic' )
	self.shape = love.physics.newCircleShape( 2 )
	self.fixture = love.physics.newFixture(self.body, self.shape, 0.01)
	self.fixture:setMask(1)
	self.fixture:setUserData(self)
	self.body:setLinearVelocity(xdir, ydir)
	self.age = age

	if age ~= 0 then
		self.health = health
	end

	table.insert( Pip.all, self )
end

function Pip:enqueue(x, y, xdir, ydir, age, health)
	table.insert(self.queue, {x, y, xdir, ydir, age, health})
end

function Pip:update_all(dt)
	-- first clear the queue
	for i = 1, #self.queue do
		Pip(self.queue[i][1], self.queue[i][2],	-- x and y position
			self.queue[i][3], self.queue[i][4],		-- x and y direction
			self.queue[i][5],		-- starting age
			self.queue[i][6])		-- starting health
	end
	self.queue = {}

	-- Cap the max number of pips at an arbitary value
	local size = #self.all
	if size > 2000 then
		local diff = size - 2000
		for i=1, diff do
			self.all[i].alive = false
		end
		print('removed', diff)
	end

	-- Then update all the objects
	local i = 1
	while i <= #self.all do
		if self.all[i].alive then
			self.all[i].age = self.all[i].age + dt
			if self.all[i].age > Pip.lifetime then self.all[i].alive = false end
			i = i + 1
		else
			self.all[i].body:destroy()
			table.remove( self.all, i )
		end
	end
end

function Pip:draw_all()
	love.graphics.setPointSize(3)
	for i = 1, #self.all do
		love.graphics.setColor(255, 255, 255, (1-(self.all[i].age/self.lifetime)) * 255)
		love.graphics.points( self.all[i].body:getX(), self.all[i].body:getY() )
	end
end

function Pip:clear_all()
	for i = 1, #self.all do
		-- delete all the bodies
		self.all[i].body:delete()
	end
	-- set the vector to empty
	self.all = {}
end

-- Sonar
-- emitted by the player when they press A
-- Inherits from Pulse
Sonar = Class{
	__includes = Pulse,
}

-- Constructor
function Sonar:init(x, y)
	self.x, self.y = x, y
	self.end_radius = 80
	self.lifetime = 1.5

	-- Add itself to the global table
	table.insert( Sonar.all, self )
end

function Sonar:draw_all()
	love.graphics.setLineWidth(3)
	for i = 1, #self.all do
		love.graphics.setColor(255, 255, 255, 200 * (1-(self.all[i].age/self.all[i].lifetime)) + 30 )
		love.graphics.circle('line', self.all[i].x, self.all[i].y, self.all[i].start_radius + (self.all[i].end_radius - self.all[i].start_radius) * (self.all[i].age/self.all[i].lifetime) + 2 )
		-- love.graphics.circle('fill', self.all[i].x, self.all[i].y, self.all[i].start_radius + (self.all[i].end_radius - self.all[i].start_radius) * (self.all[i].age/self.all[i].lifetime) + 2 )
	end
end
