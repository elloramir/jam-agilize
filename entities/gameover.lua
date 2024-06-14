-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = require("level")
local assets = require("assets")
local Entity = require("entity")
local Gameover = Entity:extend()

function Gameover:new()
    Gameover.super.new(self)
    self:set_order(ORDER_UI)
end

function Gameover:update(dt)
    if love.keyboard.isDown("r") then
        level.load()
    end
end

local white = {1, 1, 1}
local blink = {1, 1, 1, 1}

function Gameover:draw()
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

    local wooble = math.sin(love.timer.getTime()*5) * 0.1

    love.graphics.setColor(1, 1, 1)
    assets.belle_head:draw(WIDTH/2, HEIGHT/2 - 30, 0.5, 0.5, wooble)

    -- blink effect
    blink[4] = math.abs(math.sin(love.timer.getTime()*5))

    love.graphics.setFont(assets.font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        {
            white, "GAME OVER!\n",
            blink, "Press R to restart",
        }, 0, HEIGHT/2, WIDTH, "center")
end

return Gameover