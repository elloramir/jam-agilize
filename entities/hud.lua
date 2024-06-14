-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local Entity = require("entity")
local Hud = Entity:extend()

function Hud:new()
  Hud.super.new(self)
  self:set_order(ORDER_UI)

  self.belle_spr = assets.belle_neutral
end

function Hud:update(dt)
    if love.keyboard.isDown("a") then self.belle_spr = assets.belle_right
    elseif love.keyboard.isDown("d") then self.belle_spr = assets.belle_left
    else
        self.belle_spr = assets.belle_neutral
    end
end

local function circle_out(x, y, r)
    love.graphics.setColor(0.4, 0.25, 0.4, 0.7)
    love.graphics.circle("fill", x, y, r)
    love.graphics.setColor(0.5, 0.35, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", x, y, r)
end

function Hud:draw()
    circle_out(15, HEIGHT - 10, 70)
    -- circle_out(100, HEIGHT - 10, 40)
    love.graphics.setColor(1, 1, 1)
    self.belle_spr:draw(0, HEIGHT, 0, 1)
end

return Hud