State = Class{
	bg = {0, 0, 0},
}

function State:add_entity( e )
	table.insert( self.entities, e )
end

MenuState = Class{
	__includes = State,
	index = 1,
	items = {}
}

function MenuState:keypressed( keycode, scancode, isrepeat )
	if scancode == "up" then

		self.index = self.index - 1
		if self.index < 1 then self.index = #self.items end

	elseif scancode == "down" then

		self.index = self.index + 1
		if self.index > #self.items then self.index = 1 end

	else
		-- call the function that is the name of the selected item
		self[self.items[self.index]]( keycode, scancode, isrepeat )
	end
end