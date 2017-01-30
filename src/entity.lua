-- Entity
Entity = Class{
	x = 0,
	y = 0,
	alive = true,
	name = 'entity'
}

function Entity:init(x, y)
	self.x, self.y = x, y
end

function Entity:update(dt)
end

function Entity:draw()
	love.graphics.points(self.x, self.y)
end