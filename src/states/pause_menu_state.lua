pause_menu_state = MenuState()

function pause_menu_state:init()
	self.bg = {0, 0, 0, 100}
	self.title = ''
	self:add_item('Resume', 'resume')
	self:add_item('Restart', 'restart')
	self:add_item('Switch Level', 'switch level')
	self:add_item('Quit to Main Menu', 'return')
	self.lava_death_messages = {}
	self.zombie_death_messages = {}
	self.entry_condition = ''

	-- Juice for time variable
	self.time_colour = {100,100,255}
	self.time_timer = nil
	--pause_menu_state.cycle_timer_colour()
 
	for line in love.filesystem.lines("res/text/killed_by_zombie.txt") do
	  table.insert(self.zombie_death_messages, line)
	end

	for line in love.filesystem.lines("res/text/killed_by_lava.txt") do
	  table.insert(self.lava_death_messages, line)
	end
end

function pause_menu_state:enter(previous, condition)
	self.index = 1
	self.entry_condition = condition

	-- If the level has finished, give us the option to restart first
	if Level.finished() then
		self.index = 2
	end

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

function pause_menu_state:leave()
	--Timer.cancel(self.time_timer)
end

-- triggered when resume is highlighted
pause_menu_state['resume'] = function( self, scancode )
	if (scancode == 'space' or controller_1:button_pressed_a()) and self.entry_condition == 'paused' then
		Gamestate.switch(playing_state)
	end
end

-- triggered when restart is highlighted
pause_menu_state['restart'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		Level.restart()
		Gamestate.switch(playing_state)
	end
end

-- triggered when switch level is highlighted
pause_menu_state['switch level'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		Gamestate.switch(level_select_state)
	end
end

-- triggered when quit to main menu is highlighted
pause_menu_state['return'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		Gamestate.switch(main_menu_state)
	end
end

function pause_menu_state:update(dt)
	-- Toggle pause menu with controller pause button
	if controller_1:button_pressed_start() and controller_1.device ~= 'keyboard' and self.entry_condition == 'paused' then
		Gamestate.switch(playing_state)
	end

	self:navigate_menu()
end

function pause_menu_state:draw()
	playing_state:draw()

	love.graphics.setColor(self.bg)
	love.graphics.rectangle('fill', 0, 0, window_width, window_height)

    love.graphics.setColor(1,1,1)
    self:draw_menu_title(self.title)

    -- display menu items
    for i = 1, #self.items do
    	love.graphics.setColor(1,1,1)
    	
    	local item_name = self.items[i].name
    	local item_action = self.items[i].action

    	-- Grey out the reume icon if we are finished
    	if item_action == 'resume' and Level.finished() then
    		love.graphics.setColor(0.5,0.5,0.5)
    	end

    	self:draw_menu_item(item_name, i)
    end

    -- Display time taken
    if Level.won then
    	local time = string.format('Time: %.2fs', Level.finish_time - Level.start_time)

    	love.graphics.setColor(self.time_colour)
    	love.graphics.print(time, 20, 100 + 30 * (#self.items + 1))
    end
end

function pause_menu_state:keypressed( keycode, scancode, isrepeat )
	MenuState.keypressed( self, keycode, scancode, isrepeat )

	if scancode == 'escape' and self.entry_condition == 'paused' then
		Gamestate.switch(playing_state)
	end
end

function pause_menu_state.cycle_timer_colour()
	local self = pause_menu_state

	if self.time_colour[3] > 200 then
		-- If its blue, go to red
		self.time_timer = Timer.tween(0.5, self.time_colour, {255,100,100}, 'in-out-quad', pause_menu_state.cycle_timer_colour)
	elseif self.time_colour[1] > 200 then
		-- If its red, go to green
		self.time_timer = Timer.tween(0.5, self.time_colour, {100,255,100}, 'in-out-quad', pause_menu_state.cycle_timer_colour)
	elseif self.time_colour[2] > 200 then
		-- If its green, go to blue
		self.time_timer = Timer.tween(0.5, self.time_colour, {100,100,255}, 'in-out-quad', pause_menu_state.cycle_timer_colour)
	end
end