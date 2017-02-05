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

level_select_state['level'] = function( self )
	if controller_1:button_pressed_a() then
		-- Load the currently selected level and go to playing state
		Level.load(self.level_list[self.level_index])
		Gamestate.switch(playing_state)
	elseif controller_1:button_pressed_left() then
		self.level_index = self.level_index - 1
		if self.level_index < 1 then self.level_index = #self.level_list end
	elseif controller_1:button_pressed_right() then
		self.level_index = self.level_index + 1
		if self.level_index > #self.level_list then self.level_index = 1 end
	end
end

level_select_state['return'] = function( self )
	if controller_1:button_pressed_a() then
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
	local items = love.filesystem.getDirectoryItems('res/levels')
	self.level_list = {}

	-- only add PNGs to the level list
	for i = 1, #items do
		if GetFileExtension(items[i]) == ".png" then
			table.insert( self.level_list, items[i] )
		end
	end
end

function level_select_state:draw()
	love.graphics.setBackgroundColor(self.bg)
	love.graphics.print('level select...', 20, 20)

	-- Iterate over the list of menu items
	for i = 1, #self.items do
		local item = self.items[i]

		if item == 'level' then
			item = GetFileNameWithoutExtension(self.level_list[self.level_index])
		end

		-- Indicate where we will be returning to
		if item == 'return' then
			if self.previous == main_menu_state then
				item = item..' to main menu'
			elseif self.previous == playing_state then
				item = item..' to game'
			elseif self.previous == pause_menu_state then
				item = item..' to pause menu'
			end
		end

		-- prepend > to indicate the selected item
		if i == self.index then
			item = '> '..item
		end

		love.graphics.print(item, 20, 80 + 30 * i)
	end
end
