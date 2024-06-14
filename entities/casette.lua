-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local tick = require("tick")
local flux = require("flux")
local assets = require("assets")
local Entity = require("entity")
local Casette = Entity:extend()

function Casette:new(x, y)
    Casette.super.new(self)
    self:set_order(ORDER_UI)

    self:choose_music()
end

function Casette:choose_music()
    self:casette_animation()
    assets.sfx_casette_switch:play()
    tick.delay(function()
        assets.music:play()
        assets.music:setVolume(0.5)
    end, 1.3)
end

function Casette:casette_animation()
    self.casette_offset = 50
    self.tween = flux.to(self, 0.75, {casette_offset = 0})
        :ease("backout")
end

function Casette:draw()
    love.graphics.setFont(assets.font)

    do
        local x = WIDTH - 20 - assets.casette.width/2
        local y = HEIGHT - 10 + self.casette_offset - assets.casette.height/2
        local angle = 0

        -- wooble animation
        if self.casette_offset == 0 then
            angle = math.sin(love.timer.getTime() * 5) * math.pi / 16
            x = x + math.sin(love.timer.getTime() * 5) * 2
            y = y + math.cos(love.timer.getTime() * 5) * 2
        end

        assets.casette:draw(x, y, 0.5, 0.5, angle)
    end

    do
        local font = love.graphics.getFont()
        local tw = font:getWidth("Speed For Life")
        local th = font:getHeight()

        local x = WIDTH - 25 - assets.casette.width - tw + self.casette_offset
        local y = HEIGHT - 10 - assets.casette.height/2 - th/2

        -- wooble animation
        local angle = math.sin(self.casette_offset * 0.1) * 0.3

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Speed For Life", x, y, tw, "right", angle)
    end
end

return Casette