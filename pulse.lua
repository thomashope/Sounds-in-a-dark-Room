-- Pulse
-- Emitted by all things that make a noise
-- Inherits from Entity
Pulse = Class{
	__includes = Entity,
	start_radius = 0,
	end_radius = 10,
	lifetime = 1,
	color = {255,255,255},
	name = 'pulse',
	age = 0,
	pips = {},
	all = {}				-- Contains all instances of Pulse, Each subclass uses it's own table
}

function Pulse:init(x, y, speed, count, lifetime)
	self.x, self.y = x, y
	self.pips = {}
	self.lifetime = lifetime

	local shape = love.physics.newCircleShape(2)
	local xdir, ydir = 0, 1
	local incr = (math.pi*2)/count

	for i = 1, count do
		local fixture = love.physics.newFixture(
			love.physics.newBody(Physics.world, x, y, 'dynamic'),
			love.physics.newCircleShape(2),
			0.01 )
		fixture:setRestitution(1)
		fixture:setUserData(self) -- 
		fixture:setMask(1)
		fixture:getBody():setLinearVelocity(xdir*speed, ydir*speed)
		xdir, ydir = Vector.rotate(incr, xdir, ydir)

		table.insert( self.pips, fixture )
	end

	table.insert( Pulse.all, self )
	return self
end

function Pulse:update(dt)
	if self.alive then
		self.age = self.age + dt
		if self.age > self.lifetime then
			self.alive = false

			-- Remove all the pips
			for i = 1, #self.pips do
				self.pips[i]:destroy()
			end
			self.pips = {}
		end
	end
end

function Pulse:draw()
	-- if self.alive then
		love.graphics.setColor(self.color[1], self.color[2], self.color[3], 300*(1-(self.age / self.lifetime)) )
		for i = 1, #self.pips do
			love.graphics.points(self.pips[i]:getBody():getPosition())
		end
	-- end
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
	love.graphics.setPointSize(3)
	for i = 1, #self.all do
		self.all[i]:draw()
	end
end

function Pulse:clear_all()
	-- for each pulse
	for i = 1, #self.all do
		-- destroy each pip
		for j = 1, #self.all[i].pips do
			self.all[i].pips[j]:destroy()
		end
		-- and empty the table
		self.all[i].pips = {}
	end
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

-- Constructor
function Pip:init(x, y, xdir, ydir, age, health)
	self.body = love.physics.newBody( Physics.world, x, y, 'dynamic' )
	self.shape = love.physics.newCircleShape( 2 )
	self.fixture = love.physics.newFixture(self.body, self.shape, 0.01)
	self.fixture:setMask(1)
	self.fixture:setUserData(self)
	self.fixture:setRestitution(1)
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

function Pip:redirect(x, y, xdir, ydir)
	self.changed = true
	self.x = x
	self.y = y
	self.xdir = xdir
	self.ydir = ydir
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
			-- If it changed, apply changes
			if self.all[i].changed then
				self.all[i].body:setPosition(self.all[i].x, self.all[i].y)
				self.all[i].body:setLinearVelocity(self.all[i].xdir, self.all[i].ydir)
				self.all[i].changed = nil
			end

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
		self.all[i].body:destroy()
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
