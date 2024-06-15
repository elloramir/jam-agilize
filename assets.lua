-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Sheet = require("sheet")
local Sound = require("sound")
local assets = {}

function assets.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setLineStyle("rough")

  assets.belle_head = Sheet("assets/head.png")
  assets.belle_neutral = Sheet("assets/neutral.png")
  assets.belle_right = Sheet("assets/right.png")
  assets.belle_left = Sheet("assets/left.png")
  assets.belle_bad = Sheet("assets/bad.png")

  assets.power_disco = Sheet("assets/disco.png")
  assets.power_life = Sheet("assets/life.png")
  assets.power_move_spd = Sheet("assets/move_speed.png")
  assets.power_tank = Sheet("assets/tank.png")
  assets.power_one_more = Sheet("assets/one_more.png")
  assets.power_fire_rate = Sheet("assets/fire_rate.png")
  assets.power_damage = Sheet("assets/damage.png")

  assets.powerups = {
    -- { name = "disco", sheet = assets.power_disco },
    { name = "life", sheet = assets.power_life, desc = "fill your life bar" },
    { name = "move_spd", sheet = assets.power_move_spd, desc = "you move faster" },
    { name = "tank", sheet = assets.power_tank, desc = "increase your max life" },
    { name = "one_more", sheet = assets.power_one_more, desc = "+1 bullet" },
    { name = "fire_rate", sheet = assets.power_fire_rate, desc = "shots faster" },
    { name = "damage", sheet = assets.power_damage, desc = "deal more damage" },
  }

  assets.speedometer = Sheet("assets/speedometer.png")
  assets.pointer = Sheet("assets/pointer.png")
  assets.lifebar = Sheet("assets/lifebar.png")
  assets.life_tip = Sheet("assets/life_tip.png")
  assets.beam = Sheet("assets/beam.png")
  assets.casette = Sheet("assets/casette.png")
  assets.enemies = Sheet("assets/enemies.png", 32, 32)
  assets.blood = Sheet("assets/blood.png", 20, 10)
  assets.player_car = Sheet("assets/car.png")
  assets.trail = Sheet("assets/trail.png")

  assets.engine_sfx = love.audio.newSource("assets/engine.mp3", "static")
  assets.engine_sfx:setLooping(true)

  assets.shader_solid_color = love.graphics.newShader([[
    vec4 effect(vec4 col, Image img, vec2 pos, vec2 screenPos) {
        return Texel(img, pos).a * col;
    }
  ]])

  assets.sfx_crash_1 = Sound("assets/crash_1.mp3")
  assets.sfx_crash_2 = Sound("assets/crash_2.mp3")
  assets.sfx_crash_3 = Sound("assets/crash_3.mp3")
  assets.sfx_body_hit = Sound("assets/body_hit.mp3")
  assets.sfx_casette_switch = Sound("assets/casette_switch.mp3")
  assets.sfx_shoot_1 = Sound("assets/shoot.mp3")
  assets.sfx_shoot_2 = Sound("assets/shoot_2.mp3")
  assets.sfx_gameover = Sound("assets/gameover.mp3")
  assets.sfx_gameready = Sound("assets/game_restart.mp3")
  assets.sfx_pickup = Sound("assets/pickup.mp3")
  assets.sfx_count_down = Sound("assets/count_down.mp3")
  assets.sfx_pick_card = Sound("assets/pick_card.mp3")
  assets.sfx_show_card = Sound("assets/show_card.mp3")

  assets.font = love.graphics.newImageFont("assets/font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")

  assets.music_setlist = {
    { "Speed For Life", love.audio.newSource("assets/race_music.mp3", "stream") },
    { "The Chase", love.audio.newSource("assets/music_2.ogg", "stream") },
    { "Beloved Car", love.audio.newSource("assets/music_3.ogg", "stream") },
    { "Racing Against", love.audio.newSource("assets/music_4.ogg", "stream") },
  }
end

return assets
