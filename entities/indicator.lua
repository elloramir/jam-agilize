-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local Entity = require("entity")
local Indicator = Entity:extend()

function Indicator:new(x, y, text)
    Indicator.super.new(self)
    self:set_order(ORDER_UI)
    self.x = x
    self.y = y
    self.text = text
    self.scale = 0.5
    self.rotation = math.random(-1, 1) * math.random() * 0.3
end

function Indicator:update(dt)
    self.scale = self.scale + dt * 2
    if self.scale > 1.3 then
        self:destroy()
    end
end

function Indicator:draw()
    local w = assets.font:getWidth(self.text)
    local h = assets.font:getHeight()

    love.graphics.setFont(assets.font)
    love.graphics.setColor(1, 0.5, 0.5)
    love.graphics.print(self.text, self.x, self.y, self.rotation, self.scale, self.scale, w / 2, h / 2)
end

return Indicator