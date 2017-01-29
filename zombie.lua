-- Zombie
-- Created by the level
-- Inherits from Entity
Zombie = Class{
	__includes = Entity,
	size = 15,
	all = {},
	name = 'zombie'
}

-- TODO: can I recycle the shape across all zombies?
--       Would have to modify the delte function to not affect the shape

-- Constructor
function Zombie:init(x, y)
	self.x, self.y = x, y

	self.body = love.physics.newBody( Physics.world, self.x, self.y, 'dynamic' )
	self.shape = love.physics.newCircleShape( self.size )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setRestitution( 0 )
	self.fixture:setCategory(2)
	self.fixture:setUserData( self )

	table.insert( Zombie.all, self )
end

function Zombie:delete()
	if self.alive then
		self.body:destroy()
		self.alive = false
	end
end

function Zombie:update(dt)
	self.x = self.body:getX()
	self.y = self.body:getY()
end

function Zombie:draw()
	love.graphics.setColor(0, 255, 0)
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
	love.graphics.setColor(0, 255, 0)
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
