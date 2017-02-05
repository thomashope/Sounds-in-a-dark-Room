pause_menu_state = MenuState()

function pause_menu_state:init()
	self.bg = {0, 0, 0, 100}
	self.title = ''
	self.items = {'restart', 'switch level', 'quit to main menu'}
	self.lava_death_messages = {}
	self.zombie_death_messages = {}
	self.entry_condition = ''

	for line in love.filesystem.lines("res/text/killed_by_zombie.txt") do
	  table.insert(self.zombie_death_messages, line)
	end

	for line in love.filesystem.lines("res/text/killed_by_lava.txt") do
	  table.insert(self.lava_death_messages, line)
	end
end

function pause_menu_state:enter(previous)
	self.index = 1
	self.entry_condition = condition

	if Level.won then
		self.title = 'YOU KILLED EVERYTHING\n'
	elseif Level.killed_by == 'lava' then
		self.title = self.lava_death_messages[love.math.random(#self.lava_death_messages)]
	elseif Level.killed_by == 'zombie' then
		self.title = self.zombie_death_messages[love.math.random(#self.zombie_death_messages)]
	else
		self.title = ''
	end
end

-- trigered when restart is highlighted
pause_menu_state['restart'] = function( self, keycode, scancode, isrepeat )
	if controller_1:button_pressed_a() then
		Level.restart()
		Gamestate.switch(playing_state)
	end
end

-- triggered when switch level is highlighted
pause_menu_state['switch level'] = function( self, keycode, scancode, isrepeat )
	if controller_1:button_pressed_a() then
		print('switch level')
		Gamestate.switch(level_select_state)
	end
end

-- triggered when quit to main menu is highlighted
pause_menu_state['quit to main menu'] = function( self, keycode, scancode, isrepeat )
	if controller_1:button_pressed_a() then
		Gamestate.switch(main_menu_state)
	end
end

function pause_menu_state:update(dt)
	if controller_1:button_pressed_start() and self.entry_condition == 'paused' then
		Gamestate.switch(playing_state)
	end

	self:navigate_menu()
end

function pause_menu_state:draw()
	playing_state:draw()

	love.graphics.setColor(self.bg)
	love.graphics.rectangle('fill', 0, 0, window_width, window_height)

    love.graphics.setColor(255,255,255)
    -- Title at the top of the screen
    love.graphics.print(self.title, 20, 20, 0, 3, 3)

    -- display menu items
    for i = 1, #self.items do
    	local string = self.items[i]
    	if i == self.index then string = "> "..string end
    	love.graphics.print(string, 20, 80 + 30 * i)
    end

    -- Display time take
    if Level.won then
    	local time = string.format('Time: %.2fs', Level.finish_time - Level.start_time)

    	love.graphics.print(time, 20, 220)
    end
end

function pause_menu_state:keypressed( keycode, scancode, isrepeat )
	MenuState.keypressed( self, keycode, scancode, isrepeat )

	if scancode == 'escape' and self.entry_condition == 'paused' then
		Gamestate.switch(playing_state)
	end
end