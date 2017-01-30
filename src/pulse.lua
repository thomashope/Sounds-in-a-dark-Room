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
	spawn_time = 0,
	all = {}				-- Contains all instances of Pulse, Each subclass uses it's own table
}

function Pulse:init(x, y, speed, count, lifetime, mask)
	self.x, self.y = x, y
	self.pips = {}
	self.lifetime = lifetime
	self.spawn_time = love.timer.getTime()

	local shape = love.physics.newCircleShape(2)
	local xdir, ydir = 0, 1
	local incr = (math.pi*2)/count
	mask = mask or 1

	for i = 1, count do
		local fixture = love.physics.newFixture(
			love.physics.newBody(Physics.world, x, y, 'dynamic'),
			love.physics.newCircleShape(2),
			0.01 )
		fixture:setRestitution(1)
		fixture:setUserData(self) -- 
		fixture:setMask(mask)

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