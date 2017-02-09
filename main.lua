-- Load the required hump modules
Gamestate = require 'lib.hump.gamestate'
Camera = require 'lib.hump.camera'
Timer = require 'lib.hump.timer'
Class = require 'lib.hump.class'
Vector = require 'lib.hump.vector-light'

-- Load game modules
require 'src.utils'
require 'src.state'
require 'src.splash_screen_state'
require 'src.main_menu_state'
require 'src.pause_menu_state'
require 'src.options_menu_state'
require 'src.level_select_state'
require 'src.credits_screen_state'
require 'src.controller_prompt_state'
require 'src.playing_state'
require 'src.console_state'
require 'src.input_device'
require 'src.physics'
require 'src.level'
require 'src.audio'
require 'src.entity'
require 'src.pulse'
require 'src.player'
require 'src.zombie'
require 'src.wall'

--[[
- TODO: improve the Timer.tween functions...
	When additional arguments are given they are passed as arguments
	to the 'after' function (they are currently passed to the tweening funciton)
	replace the tweening function string with a string or table value to pass
	additional arguments when required 
- TODO: scale menus for fullscreen
- TODO: prompt user when trying to use keyboard while controller is connected
--]]

function love.load()
	-- Application setup
	Physics:init()
	love.mouse.setVisible(false)
	love.graphics.setNewFont(18)
	love.audio.setVolume(0.5)
	love.math.setRandomSeed(love.timer.getTime())

	-- Set globals
	window_width, window_height = love.graphics.getDimensions()
	platform = love.system.getOS()

	player = Player(0, 0)
	camera = Camera(player.x, player.y)
	controller_1 = InputDevice()

	-- Initialise the game states
	Gamestate.registerEvents()
	Gamestate.switch(splash_screen_state)
end

function love.update(dt)
	Timer.update(dt)
	controller_1:update()
end

function love.resize(w,h)
	window_width = w
	window_height = h
	playing_state.pips = love.graphics.newCanvas(w, h)
end

function love.keypressed( keycode, scancode, isrepeat )
	-- Open up the console from any state
	if scancode == 'f1' then
		if Gamestate.current() == console_state then
			Gamestate.switch(console_state.previous)
		else
			Gamestate.switch(console_state)
		end
	end
end

function love.joystickadded( joystick )
	controller_1:set_input_source( joystick )
	joystick:setVibration(0.5, 0.5, 0.2)
end

function love.joystickremoved()
	controller_1:set_input_source()
end