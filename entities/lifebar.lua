-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = require("level")
local assets = require("assets")
local Entity = require("entity")
local Lifebar = Entity:extend()

local MAX_TIPS = 20

function Lifebar:new()
    Lifebar.super.new(self)
    self:set_order(ORDER_UI)
end

function Lifebar:draw()
    local x = 40
    local y = HEIGHT - 70
    local percent = level.player.life_still / level.player.max_life
    local tips = math.floor(MAX_TIPS * percent)

    love.graphics.setColor(1, 1, 1)
    assets.lifebar:draw(x, y)
    for i = 1, tips do
        assets.life_tip:draw(assets.life_tip.width*i + x + 4, y + 8)
    end
end

return Lifebar