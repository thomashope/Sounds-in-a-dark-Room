level_select_state = MenuState()

-- TODO: options to add,
--	* num players?
--	* timer always on (toggle)
--	* zombie counter (toggle)
--	* zombie sonar visibility (toggle)
--	* lava visibility (toggle)

function level_select_state:init()
	self.level_list = {}
	self.level_index = 1
	self.items = {'level', 'return'}

	self:update_level_list()
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

local function GetFileNameWithoutExtension(str)
  return str:match("(.+)%..+")
end

local function GetFileName(str)
  return str:match("^.+/(.+)$"):match("(.+)%..+")
end

local function GetFileExtension(str)
  return str:match("^.+(%..+)$")
end

function level_select_state:update_level_list()
	local levels = love.filesystem.getDirectoryItems('res/levels')

	self.level_list = {}
	self.items = {}

	-- only add PNGs to the level list
	for i = 1, #levels do
		print(i, levels[i])
		if GetFileExtension(levels[i]) == ".png" then
			table.insert( self.items, 'level' )
			table.insert( self.level_list, levels[i] )
		end
	end

	table.insert( self.items, 'return' )
end

function level_select_state:get_return_menu_item_string()
	if self.previous == main_menu_state then
		return 'return to main menu'
	elseif self.previous == playing_state then
		return 'return to game'
	elseif self.previous == pause_menu_state then
		return 'return to pause menu'
	end
end

function level_select_state:draw()
	love.graphics.setBackgroundColor(self.bg)
	love.graphics.setColor(255,255,255)
	love.graphics.print('level select...', 20, 20)

	-- Iterate over the list of menu items
	for i = 1, #self.items do
		local item = self.items[i]

		if item == 'level' then
			item = GetFileNameWithoutExtension(self.level_list[i])
		end

		-- Indicate where we will be returning to
		if item == 'return' then
			item = self:get_return_menu_item_string()
		end

		-- prepend > to indicate the selected item
		if i == self.index then
			item = '> '..item
		end

		love.graphics.print(item, 20, 80 + 30 * i)
	end
end
