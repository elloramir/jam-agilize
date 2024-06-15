-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local tick = require("tick")
local level = require("level")
local Entity = require("entity")
local Hordes = Entity:extend()

function Hordes:new()
    Hordes.super.new(self)

    self.index = 1
    self:spawn_cards()
end

function Hordes:next_horde()
    self.total_enemies = self.index * 10
    self.index = self.index + 1

    for i = 1, self.total_enemies do 
        level.add_entity("enemy", i, self.index)
    end
end

function Hordes:spawn_cards()
    local chooses = {}

    for i = 1, 3 do
        local choose
        while true do
            choose = math.random(1, #assets.powerups)
            if not chooses[choose] then
                chooses[choose] = true
                break
            end
        end

        level.add_entity("card", i, assets.powerups[choose])
    end
end

return Hordes