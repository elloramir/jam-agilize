-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local Entity = require("entity")
local Flash = Entity:extend()

function Flash:new(x, y)
    Flash.super.new(self)
    self:set_order(ORDER_PLAYER+1)
    self.x = x
    self.y = y
end

function Flash:update(dt)
end

function Flash:draw()
end

return Flash