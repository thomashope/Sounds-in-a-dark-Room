main_menu_state = MenuState()

function main_menu_state:init()
	self.items = {'play', 'options', 'quit'}
end

function main_menu_state:update(dt)
end

function main_menu_state:draw()
    love.graphics.print("Main menu...", 20, 20)

    for i = 1, #self.items do
    	local string = self.items[i]
    	if i == self.index then string = "> "..string end
    	love.graphics.print(string, 20, 50 + 20 * i)
    end
end

main_menu_state['play'] = function( keycode, scancode, isrepeat )
	if scancode == "space" then
		Gamestate.switch(playing_state)
	end
end

main_menu_state['options'] = function( keycode, scancode, isrepeat )
end

main_menu_state['quit'] = function( keycode, scancode, isrepeat )
	love.event.quit()
end