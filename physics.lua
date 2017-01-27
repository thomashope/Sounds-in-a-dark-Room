-- Singleton physics object
Physics = {
	world = nil,
	meter = 30		-- pixels per meter
}

function Physics.init()
	Physics.world = love.physics.newWorld( 0, 0, false )
	love.physics.setMeter( Physics.meter )
end

function Physics.update(dt)
	Physics.world:update(dt)
end