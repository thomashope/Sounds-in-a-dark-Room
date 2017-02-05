State = Class{
	bg = {0, 0, 0}
}

MenuState = Class{
	__includes = State,
	index = 1,
	items = {}
}

function MenuState:enter()
	self.index = 1
end

function MenuState:call_selected_item()
	self[self.items[self.index]]( self )
end

function MenuState:update()
	self:navigate_menu()
end

function MenuState:navigate_menu()
	if controller_1:button_pressed_up() then
		self.index = self.index - 1
	elseif controller_1:button_pressed_down() then
		self.index = self.index + 1
	end
	-- Keep the  index in the range of the menu
	self.index = math.wrap( self.index, 1, #self.items )

	if controller_1:button_pressed_any() then
		self:call_selected_item()
	end
end

function MenuState:keypressed( keycode, scancode, isrepeat )
	if scancode == "up" then

		self.index = self.index - 1

	elseif scancode == "down" then

		self.index = self.index + 1

	else
		self:call_selected_item( keycode, scancode, isrepeat )
	end

	self.index = math.wrap( self.index, 1, #self.items )
end