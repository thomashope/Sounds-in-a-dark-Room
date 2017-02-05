console_state = State()

function console_state:init()
	self.previous = nil
	self.bg = {0,0,0,100}

	self.history = {}
	self.history_index = 0

	self.input = ''

	table.insert( self.history, {text="Welcome to THE CONSOLE!", colour={100,100,100}})
	table.insert( self.history, {text="May I say, you look lovely today", colour={100,100,100}} )
	table.insert( self.history, {text="Very intelligent also", colour={100,100,100}} )
end

function console_state:enter(previous)
	self.previous = previous
	self.history_index = 0
end

function console_state:update(dt)
	if #self.history > 64 then
		table.remove(self.history, 1)
	end
end

function console_state:textinput( text )
	self.input = self.input..text
end

function console_state:evaluate( text )
	-- TODO: use regex to extract text before and aftere points
	-- so input 'Player.speed' is evaluated as _G[Player].speed
	-- Allow the evaluation or arbitrary lua code??????????????
	table.insert( self.history, {text=tostring(_G[text]), colour={100,100,100}})
end

function console_state:selected_text()
	if self.history_index == 0 then
		return self.input
	else
		return self.history[#self.history - self.history_index + 1].text
	end
end

function console_state:keypressed( keycode, scancode, isrepeat )
	if scancode == 'return' and self:selected_text() ~= '' then

		-- run the input and add it to the hisotry
		table.insert( self.history, {text=self:selected_text(), colour={255,255,255}} )
		self:evaluate( self:selected_text() )

		-- clear the input field
		self.input = ''
		self.history_index = 0
	elseif scancode == 'backspace' then

		-- delete the entire sting if ctrl is held (or command on mac)
		if platform == "OS X" and love.keyboard.isDown('lgui', 'rgui') then
			self.input = ''
		elseif love.keyboard.isDown('lctrl', 'rctrl') then
			self.input = ''
		else
			self.input = self.input:sub(1, -2)
		end
	elseif scancode == 'up' then
		self.history_index = self.history_index + 1
	elseif scancode == 'down' then
		self.history_index = self.history_index - 1
	end

	self.history_index = math.clamp( self.history_index, 0, #self.history )
end

function console_state:draw()
	self.previous:draw()

	love.graphics.setColor( self.bg )
	love.graphics.rectangle( "fill", 0, 0, window_width, window_height )

	-- Draw the hisotry in reverse order bottom to top
	for i = #self.history, 1, -1 do
		-- colorize the selected history text if any
		if i == #self.history - self.history_index + 1 then
			love.graphics.setColor( 255, 200, 100 )
		else
			love.graphics.setColor( self.history[i].colour )
		end

		love.graphics.print( self.history[i].text,
			20,
			window_height - 20 * (#self.history - i) - 80)
	end
	
	-- draw input box
	love.graphics.setColor( 0, 100, 100, 100 )
	love.graphics.rectangle( 'fill', 0, window_height - 35, window_width, window_height - 5)

	-- Draw the input line
	love.graphics.setColor(255,255,255)
	local input = love.graphics.newText( love.graphics.getFont(), ':> '..self:selected_text() )
	love.graphics.draw(input, 20, window_height - 30)
	
	love.graphics.setColor(255,255,255,100)
	love.graphics.line(20 + input:getWidth(), window_height - 30, 20 + input:getWidth(), window_height - 5)

	-- Draw pointless title
	love.graphics.setColor(0,0,0, 100)
	love.graphics.rectangle( 'fill', 10, 10, 260, 40 )
	love.graphics.setColor( 255,255,255,255 )
	love.graphics.print( "SECRET DEBUG CONSOLE", 20, 20 )
end