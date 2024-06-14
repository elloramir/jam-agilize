-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Sheet = require("sheet")
local assets = {}

function assets.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setLineStyle("rough")

  assets.player_car = Sheet("assets/car.png")
  assets.trail = Sheet("assets/trail.png")

  assets.engine_sfx = love.audio.newSource("assets/engine.mp3", "static")
  assets.engine_sfx:setLooping(true)
  assets.music = love.audio.newSource("assets/race_music.mp3", "stream")
  assets.music:play()
  assets.music:setVolume(0.5)
end

return assets
