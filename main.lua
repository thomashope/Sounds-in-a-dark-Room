-- Load the required hump modules
Gamestate = require 'lib.hump.gamestate'
Camera = require 'lib.hump.camera'
Timer = require 'lib.hump.timer'
Class = require 'lib.hump.class'
Vector = require 'lib.hump.vector-light'

-- Load game modules
require 'src.state'
require 'src.splash_screen_state'
require 'src.main_menu_state'
require 'src.pause_menu_state'
require 'src.options_menu_state'
require 'src.level_select_state'
require 'src.playing_state'
require 'src.physics'
require 'src.level'
require 'src.audio'
require 'src.entity'
require 'src.pulse'
require 'src.player'
require 'src.zombie'
require 'src.wall'

function love.load()
	-- Application setup
	Physics:init()
	love.mouse.setVisible(false)
	love.graphics.setNewFont(18)
	love.audio.setVolume(0.75)
	love.math.setRandomSeed(love.timer.getTime())

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
end

function love.resize(w,h)
	window_width = w
	window_height = h
	playing_state.pips = love.graphics.newCanvas(w, h)
end

function love.joystickadded( joystick )
	player.input = joystick
	joystick:setVibration(0.5, 0.5, 0.2)
end

function love.joystickremoved()
	player.input = 'keyboard'
end
