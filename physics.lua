-- Singleton physics object
Physics = {
	world = nil,
	meter = 50		-- pixels per meter
}

function Physics.init()
	Physics.world = love.physics.newWorld( 0, 0, false )
	love.physics.setMeter( Physics.meter )
	Physics.world:setCallbacks(
		Physics.begin_contact,
		Physics.end_contact,
		Physics.pre_solvem,
		Physics.post_solve)
end

function Physics.update(dt)
	Physics.world:update(dt)
end

local function lava_vs_zombie( lava, zombie, contact )
	zombie:delete()
end

local function lava_vs_player( lava, player, contact )
	print('lava vs player')
end

local function player_vs_zombie( player, zombie, contact )
	print('player vs zombie')
end

function Physics.begin_contact( a, b, contact )
	if (a:getUserData().name == 'lava' and b:getUserData().name == 'zombie') then
		lava_vs_zombie(a:getUserData(), b:getUserData(), contact)
	elseif (b:getUserData().name == 'lava' and a:getUserData().name == 'zombie') then
		lava_vs_zombie(b:getUserData(), a:getUserData(), contact)
	elseif (a:getUserData().name == 'lava' and b:getUserData().name == 'player') then
		lava_vs_player(a:getUserData(), b:getUserData(), contact)
	elseif (b:getUserData().name == 'lava' and a:getUserData().name == 'player') then
		lava_vs_player(b:getUserData(), a:getUserData(), contact)
	elseif (a:getUserData().name == 'player' and b:getUserData().name == 'zombie') then
		player_vs_zombie(a:getUserData(), b:getUserData(), contact)
	elseif (b:getUserData().name == 'player' and a:getUserData().name == 'zombie') then
		player_vs_zombie(b:getUserData(), a:getUserData(), contact)
	end
end

function Physics.end_contact( a, b, contact )
end

function Physics.pre_solve( a, b, contact )
end

function Physics.post_solve( a, b, contact, normal_impulse, tangent_impulse )
end