-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local level = require("level")
local Entity = require("entity")
local Timer = Entity:extend()

function Timer:new(time)
    Timer.super.new(self)
    self:set_order(ORDER_UI)

    assets.sfx_count_down:play()
    level.player.lost_control_for = 99999999999
    self.count_3 = 3.9
end

function Timer:update(dt)
    self.count_3 = self.count_3 - dt
    if self.count_3 < 0 then
        level.player.lost_control_for = 0
	    level.add_entity("casette")
	    level.horders = level.add_entity("hordes")
        self:destroy()
    end
end

function Timer:draw()
    local num = math.floor(self.count_3)

    if num == 0 then
        num = "GO!"
    end

    love.graphics.push()
    love.graphics.scale(3, 3)
    love.graphics.translate(-WIDTH/3, -HEIGHT/3)
        love.graphics.setFont(assets.font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(num, 0, HEIGHT/2, WIDTH, "center")
    love.graphics.pop()
end

return Timer