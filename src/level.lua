Level = {
	loaded = '',
	start_time = 0,
	finish_time = 0,
	won = false,
	killed_by = ''
}

function Level.load(filename)
	Level.clear()

	Physics.destroy_all_with_name('pulse')

	-- Print a bunch of debug stuff to try to find the memory leak
	print('--- restarted level ---')
	print("Player pulse caches: "..#Player.sonar_list)
	print("Player pulse cache size: "..#Player.sonar_list[1])
	print("Immidiate pulses: "..#Pulse.immidiate_instances)
	print("Preallocated pulses: "..#Pulse.preallocated_instances)
	print("Box2d: "..Physics.world:getBodyCount())

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
			elseif r >= 1 and g == 0 and b == 0 then
				io.write('L')
				Lava(x*scale, y*scale)
			elseif g >= 1 and r == 0 and b == 0 then
				io.write('Z')
				Zombie(x*scale, y*scale)
			elseif r == 0 and g == 0 and b >= 1 then
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
	Level.killed_by = ''
	Level.start_time = love.timer.getTime()
end

-- Returns true when the level has finished for some reason (won or died)
function Level.finished()
	return Level.killed_by ~= '' or Level.won
end

function Level.restart()
	Level.load(Level.loaded)
end

function Level.clear()
	Zombie:clear_all()
	Pulse:clear_all()
	Wall:clear_all()
	Lava:clear_all()


	-- local bodies = Physics.world:getBodyList()
	-- for i = 1, #bodies do
	-- 	-- if bodies[i]:getUserData() == 'pulse' then
	-- 	if not bodies[i]:isDestroyed() and bodies[i]:getUserData().name ~= 'player' then
	-- 		bodies[i]:destroy()
	-- 	end
	-- end
end
