Wall = Class{
	__includes = Entity,
	size = Physics.meter,
	all = {},
	name = 'wall'
}

function Wall:init(x, y)
	self.x, self.y = x, y

	self.body = love.physics.newBody( Physics.world, self.x, self.y, 'static' )
	self.shape = love.physics.newRectangleShape( self.size, self.size )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setRestitution( 0 )
	self.fixture:setUserData( self )
	self.fixture:setCategory( 3 )

	table.insert( Wall.all, self )
end

function Wall:delete()
	if self.alive then
		self.body:destroy()
		self.alive = false
	end
end

function Wall:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle( 'fill', self.x - self.size/2, self.y - self.size/2, self.size, self.size )
end

function Wall:update_all(dt)
	-- Remove dead walls, if there is such a thing
	local i = 1
	while i < #self.all do
		if not self.all[i].alive then
			table.remove( self.all, i )
		else
			self.all[i]:update(dt)
			i = i + 1
		end
	end
end

function Wall:draw_all()
	love.graphics.setColor(0, 0, 0)
	for i = 1, #self.all do
		love.graphics.rectangle( 'fill',
			self.all[i].x - self.all[i].size/2,	-- x pos
			self.all[i].y - self.all[i].size/2,	-- y pos
			self.all[i].size,					-- width
			self.all[i].size )					-- height
	end
end

function Wall:clear_all()
	if #self.all > 0 then
		for i = 1, #self.all do
			self.all[i]:delete()
		end
		self.all = {}
	end
end

-- Lava
-- kills things that touch it
-- Inherits from Wall
Lava = Class{
	__includes = Wall,
	name = 'lava'
}

function Lava:init(x, y)
	self.x, self.y = x, y

	self.body = love.physics.newBody( Physics.world, self.x, self.y, 'static' )
	local shape = love.physics.newRectangleShape( self.size - 10, self.size - 10 )
	self.fixture = love.physics.newFixture( self.body, shape, 1 )
	self.fixture:setRestitution( 0 )
	self.fixture:setSensor( true )
	self.fixture:setUserData( self )

	table.insert( Lava.all, self )
end

function Lava:draw_all()
	for i = 1, #self.all do
		love.graphics.setColor(200 + love.math.random(20), love.math.random(40), 0)
		love.graphics.rectangle( 'fill',
			self.all[i].x - self.all[i].size/2,	-- x pos
			self.all[i].y - self.all[i].size/2,	-- y pos
			self.all[i].size,					-- width
			self.all[i].size )					-- height
	end
end
