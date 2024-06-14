-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = require("level")
local assets = require("assets")
local Entity = require("entity")
local Lifebar = Entity:extend()

function Lifebar:new()
    Lifebar.super.new(self)
end

function Lifebar:draw()
    local percent = level.player.life_still / level.player.max_life
    local width = assets.lifebar.width * percent - 25

    love.graphics.setColor(0.7, 0.4, 0.4)
    love.graphics.rectangle("fill", 30, 12, width, 15)

    love.graphics.setColor(1, 1, 1)
    assets.lifebar:draw(10, 20, 0, 0.5)
end

return Lifebar