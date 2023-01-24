local lg = love.graphics

State = Class{
	bg = {0, 0, 0}
}

MenuState = Class{
	__includes = State,
	init = function(self)
		self.index = 1
		self.items = {}
	end
}

function MenuState:enter()
	self.index = 1
end

function MenuState:add_item(name_, action_)
	table.insert(self.items, {
		name = name_,
		action = action_,
	})
end

function MenuState:print_menu_item(name, index)
	if index == self.index then
		-- item is selected
		name = '> ' .. name
	end
	lg.print(name, 20, 80 + 30 * index)
end

function MenuState:call_selected_item( scancode )
	self[self.items[self.index].action]( self, scancode )
end

function MenuState:update()
	self:navigate_menu()
end

function MenuState:navigate_menu()
	if controller_1:button_pressed_up() then
		Audio.play_random(player.l_foot_sounds)
		self.index = self.index - 1
		self.index = math.wrap( self.index, 1, #self.items )
	elseif controller_1:button_pressed_down() then
		Audio.play_random(player.l_foot_sounds)
		self.index = self.index + 1
		self.index = math.wrap( self.index, 1, #self.items )
	elseif controller_1:button_pressed_any() then
		self:call_selected_item()
	end
end

function MenuState:keypressed( keycode, scancode, isrepeat )
	if controller_1.device ~= 'keyboard' then
		if scancode == "up" then
			self.index = self.index - 1
		elseif scancode == "down" then
			self.index = self.index + 1
		else
			self:call_selected_item( scancode )
		end
		self.index = math.wrap( self.index, 1, #self.items )
	end
end