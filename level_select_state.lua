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
	self.items = {'level', 'quit to main menu'}

	self:update_level_list()
end

function level_select_state:enter(previous)
	self:update_level_list()
	self.index = 1
end

level_select_state['level'] = function( self, keycode, scancode, isrepeat )
	if scancode == 'space' or scancode == 'return' then
		-- Load the currently selected level and go to playing state
		Level.load(self.level_list[self.level_index])
		Gamestate.switch(playing_state)
	elseif scancode == 'left' then
		self.level_index = self.level_index - 1
		if self.level_index < 1 then self.level_index = #self.level_list end
	elseif scancode == 'right' then
		self.level_index = self.level_index + 1
		if self.level_index > #self.level_list then self.level_index = 1 end
	end
end

level_select_state['quit to main menu'] = function( self, keycode, scancode, isrepeat )
	if scancode == 'space' or scancode == 'return' then
		Gamestate.switch(main_menu_state)
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
	local items = love.filesystem.getDirectoryItems('levels')
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

		if self.items[i] == 'level' then
			item = GetFileNameWithoutExtension(self.level_list[self.level_index])
		end

		-- prepend > to indicate the selected item
		if i == self.index then
			item = '> '..item
		end

		love.graphics.print(item, 20, 60 + 20 * i)
	end
end
