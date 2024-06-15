-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local tick = require("tick")
local level = require("level")
local Entity = require("entity")
local Hordes = Entity:extend()

function Hordes:new()
    Hordes.super.new(self)

    self.index = 1
    self:next_horde()
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
    for i = 1, 3 do
        level.add_entity("card", i, "kind")
    end
end

function Hordes:update(dt)
    -- check of end of horde
    -- if not self.is_preparing_stage then
    --     local en_count = 0

    --     for _, en in ipairs(level.entities) do
    --         if en.is_enemy then
    --             en_count = en_count + 1
    --         end
    --     end

    --     if en_count == 0 then
    --         self.is_preparing_stage = true
    --         -- self:next_horde()
    --     end
    -- end
end

return Hordes