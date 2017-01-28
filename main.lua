-- Load the required hump modules
Gamestate = require 'hump.gamestate'
Camera = require 'hump.camera'
Timer = require 'hump.timer'
Class = require 'hump.class'

-- Load game modules
require 'state'
require 'splash_screen_state'
require 'main_menu_state'
require 'pause_menu_state'
require 'level_select_state'
require 'playing_state'
require 'physics'
require 'level'
require 'audio'
require 'entity'
require 'pulse'
require 'player'
require 'zombie'
require 'wall'

function love.load()
	-- Application setup
	Physics:init()

	-- Set globals
	window_width, window_height = love.graphics.getDimensions()

	player = Player(0, 0)
	camera = Camera(player.x, player.y)

	-- Initialise the game states
	Gamestate.registerEvents()
	Gamestate.switch(splash_screen_state)
end

function love.update(dt)
	Timer.update(dt)
	Physics.update(dt)
end

function love.resize(w,h)
	window_width = w
	window_height = h
end

function love.joystickadded( joystick )
	player.input = joystick
	joystick:setVibration(0.5, 0.5, 0.2)
end

function love.joystickremoved()
	player.input = 'keyboard'
end