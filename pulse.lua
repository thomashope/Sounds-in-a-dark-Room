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