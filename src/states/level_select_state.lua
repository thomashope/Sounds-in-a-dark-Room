level_select_state = MenuState()

-- TODO: options to add,
--	* num players?
--	* timer always on (toggle)
--	* zombie counter (toggle)
--	* zombie sonar visibility (toggle)
--	* lava visibility (toggle)

local lg = love.graphics

function level_select_state:init()
	self.level_list = {}
	self.level_index = 1
end

function level_select_state:enter(previous)
	self:update_level_list()
	self.index = 1
	self.previous = previous
end

level_select_state['level'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		-- Load the currently selected level and go to playing state
		Level.load(self.level_list[self.index])
		Gamestate.switch(playing_state)
	end
end

level_select_state['return'] = function( self, scancode )
	if scancode == 'space' or controller_1:button_pressed_a() then
		Gamestate.switch(self.previous)
	end
end

function level_select_state:update_level_list()
	local levels = love.filesystem.getDirectoryItems('res/levels')

	self.level_list = {}
	self.items = {}

	-- only add PNGs to the level list
	for i = 1, #levels do
		if get_file_extension(levels[i]) == ".png" then
			local name_no_ext = get_filename_without_extension(levels[i])
			self:add_item(name_no_ext, 'level')
			table.insert( self.level_list, levels[i] )
		end
	end

	self:add_item('Return to...', 'return')
end

function level_select_state:get_return_menu_item_string()
	if self.previous == main_menu_state then
		return 'Return to Main Menu'
	elseif self.previous == playing_state then
		return 'Return to Game'
	elseif self.previous == pause_menu_state then
		return 'Return to Pause Menu'
	end
end

function level_select_state:draw()
	lg.setBackgroundColor(self.bg)
	lg.setColor(1,1,1)
	self:draw_menu_title('Level Select')

	-- Iterate over the list of menu items
	for i = 1, #self.items do
		local item_action = self.items[i].action
		local item_name = self.items[i].name

		-- Indicate where we will be returning to
		if item_action == 'return' then
			item_name = self:get_return_menu_item_string()
		end

		self:draw_menu_item(item_name, i)
	end
end
