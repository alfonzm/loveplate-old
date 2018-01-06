io.stdout:setvbuf("no")
tlog = require "alphonsus.tlog"

local Gamestate = require "lib.hump.gamestate"
local gamera = require "lib.gamera"
local push = require "lib.push"
local shack = require "lib.shack"

local assets = require "assets"

local PlayState = require "playstate"

function love.load()
	love.mouse.setVisible(false)

	-- setup push screen
	local windowWidth, windowHeight
	local gameWidth, gameHeight
	if G.fullscreen then
		windowWidth, windowHeight = love.window.getDesktopDimensions()
		gameWidth, gameHeight = windowWidth / G.scale, windowHeight / G.scale
	else
		gameWidth, gameHeight = G.width, G.height
		windowWidth, windowHeight = G.width * G.scale, G.height * G.scale
	end
	push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = G.fullscreen, pixelperfect = true})

	-- setup cam
	-- cam = gamera.new(0, 0, windowWidth*100, windowHeight*100)
	-- cam:setWindow(0, 0, gameWidth, gameHeight)

	-- setup screenshake
	shack:setDimensions(push:getDimensions())

	-- setup Gamestate
	Gamestate.registerEvents()
	playState = PlayState()
	Gamestate.switch(playState)
end

function love.update(dt)
	shack:update(dt)
end

function love.draw()
end

function setupBgMusic()
	-- assets.music:setVolume(0.8)
	-- assets.music:setLooping(true)
	-- assets.music:play()
end