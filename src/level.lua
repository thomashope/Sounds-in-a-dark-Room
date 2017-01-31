Level = {
	loaded = '',
	start_time = 0,
	finish_time = 0,
	won = false
}

function Level.load(filename)
	Level.clear()

	local scale = Wall.size
	local image = love.image.newImageData("res/levels/"..filename)

	print('Loading ', filename)
	for y = 0, image:getHeight()-1 do
		for x = 0, image:getWidth()-1 do
			local r, g, b, a = image:getPixel(x, y)

			if r == 0 and g == 0 and b == 0 then
				io.write('W')
				-- TODO: optimise walls into fewer larger objects where possible
				Wall(x*scale, y*scale)
			elseif r == 255 and g == 0 and b == 0 then
				io.write('L')
				Lava(x*scale, y*scale)
			elseif g == 255 and r == 0 and b == 0 then
				io.write('Z')
				Zombie(x*scale, y*scale)
			elseif r == 0 and g == 0 and b == 255 then
				io.write('P')
				player:spawn(x*scale, y*scale)
			else
				io.write(' ')
			end
		end
		io.write('\n')
	end

	Level.loaded = filename
	Level.won = false
	Level.start_time = love.timer.getTime()
end

function Level.restart()
	Level.clear()
	Level.load(Level.loaded)
end

function Level.clear()
	Zombie:clear_all()
	Pulse:clear_all()
	Wall:clear_all()
	Lava:clear_all()
end