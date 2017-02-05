Audio = {
	scale = 1/50
}

function Audio.load( folder, list )
	local result = {}
	for i = 1, #list do
		local source = love.audio.newSource( 'res/'..folder..'/'..list[i], 'static' )
		table.insert( result, source )
	end

	return result
end

function Audio.play_random( list )
	local i = love.math.random(#list)
	list[i]:stop()
	list[i]:setPosition( love.audio.getPosition() )
	list[i]:play()
end

function Audio.play_random_at( list, x, y )
	local i = love.math.random(#list)
	list[i]:stop()
	list[i]:setPosition( x * Audio.scale, y * Audio.scale, 0 )
	list[i]:play()
end

function Audio.set_listener( x, y )
	love.audio.setPosition( x * Audio.scale, y * Audio.scale, 0 )
end

function Audio.set_position( source, x, y )
	source:setPosition( x * Audio.scale, y * Audio.scale, 0 )
end