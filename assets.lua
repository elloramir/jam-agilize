-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Sheet = require("sheet")
local Sound = require("sound")
local assets = {}

function assets.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setLineStyle("rough")

  assets.belle_neutral = Sheet("assets/neutral.png")
  assets.belle_right = Sheet("assets/right.png")
  assets.belle_left = Sheet("assets/left.png")
  assets.belle_bad = Sheet("assets/bad.png")

  assets.enemies = Sheet("assets/enemies.png", 32, 32)
  assets.blood = Sheet("assets/blood.png", 20, 10)
  assets.player_car = Sheet("assets/car.png")
  assets.trail = Sheet("assets/trail.png")

  assets.engine_sfx = love.audio.newSource("assets/engine.mp3", "static")
  assets.engine_sfx:setLooping(true)
  assets.music = love.audio.newSource("assets/race_music.mp3", "stream")
  -- assets.music:play()
  assets.music:setVolume(0.5)

  assets.shader_solid_color = love.graphics.newShader([[
    vec4 effect(vec4 col, Image img, vec2 pos, vec2 screenPos) {
        return Texel(img, pos).a * col;
    }
  ]])

  assets.sfx_crash_1 = Sound("assets/crash_1.mp3")
  assets.sfx_crash_2 = Sound("assets/crash_2.mp3")
  assets.sfx_crash_3 = Sound("assets/crash_3.mp3")
  assets.sfx_body_hit = Sound("assets/body_hit.mp3")
end

return assets
