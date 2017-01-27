Wall = Class{
	__includes = Entity,
	size = Physics.meter,
	all = {}
}

function Wall:init(x, y)
	self.x, self.y = x, y
	
	self.body = love.physics.newBody( Physics.world, self.x, self.y, 'static' )
	self.shape = love.physics.newRectangleShape( self.size, self.size )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setRestitution( 0 )

	table.insert( Wall.all, self )
end

function Wall:destroy()
	self.body:destroy()
	self.alive = false
end

function Wall:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle( 'fill', self.x - self.size/2, self.y - self.size/2, self.size, self.size )
end

function Wall:draw_all()
	love.graphics.setColor(0, 0, 0)
	for i = 1, #self.all do
		self.all[i]:draw()
	end
end