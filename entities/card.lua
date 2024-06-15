-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local assets = require("assets")
local tick = require("tick")
local level = require("level")
local flux = require("flux")
local Entity = require("entity")
local Card = Entity:extend()

Card.is_card = true

local CARD_WIDTH = 100
local CARD_HEIGHT = 160
local CARD_MARGIN = 30
local CARD_TOTAL = 3 
local CARD_X = (WIDTH - (CARD_WIDTH * CARD_TOTAL + CARD_MARGIN * (CARD_TOTAL - 1))) / 2

function Card:new(index, kind)
    Card.super.new(self)

    self:set_order(ORDER_UI + 1)

    self.kind = kind
    self.index = index
    self.disabled = false
    self.x = math.floor((index - 1) * CARD_WIDTH + CARD_X + (index - 1) * CARD_MARGIN)
    self.y = math.floor((HEIGHT - CARD_HEIGHT) / 2)
    self.offset = 300
    self.done_anim = false

    tick.delay(function()
        assets.sfx_show_card:play():setPitch(1 + (index - 1) * 0.1)
        flux.to(self, 1, {offset = 0}):ease("backout"):oncomplete(function()
            self.done_anim = true
        end)
    end, (index - 1) * 0.25)
end

function Card:activate_effect()
    local kind = self.kind

    if kind.name == "disco" then
    elseif kind.name == "life" then
        level.player.life = level.player.max_life
    elseif kind.name == "move_spd" then
        level.player.max_spd = math.floor(level.player.max_spd * 1.15)
    elseif kind.name == "tank" then
        level.player.max_life = level.player.max_life + 1
    elseif kind.name == "one_more" then
        level.player.bullets_per_shot = level.player.bullets_per_shot + 1
    elseif kind.name == "fire_rate" then
        level.player.fire_rate = level.player.fire_rate * 0.8
    elseif kind.name == "damage" then
        level.player.damage = level.player.damage * 1.5
    end
end

function Card:cursor_is_over()
    local mx, my = get_mouse()

    return
        mx >= self.x and mx <= self.x + CARD_WIDTH and
        my >= self.y + self.offset and my <= self.y + self.offset + CARD_HEIGHT
end

function Card:update(dt)
    if not self.done_anim or self.disabled then
        return
    end

    local is_over = self:cursor_is_over()
    local target = is_over and -20 or 0
    self.offset = lerp(self.offset, target, 10*dt)

    if is_over and love.mouse.isDown(1) then
        -- disable all cards
        for _, en in ipairs(level.entities) do
            if en.is_card then
                en.disabled = true
            end
        end

        -- make that gone
        self:destroy()
        assets.sfx_pick_card:play()
        self:activate_effect()

        -- destroy others after x seconds
        tick.delay(function()
            for _, en in ipairs(level.entities) do
                if en.is_card then
                    en:gone_until_destroy()
                end
            end
            level.horders:next_horde()
        end, 1)
    end
end

function Card:gone_until_destroy()
    self.done_anim = false
    flux.to(self, 0.5, {offset = 300}):ease("backin"):oncomplete(function()
        self:destroy()
    end)
end

function Card:post_draw()
    -- shadow
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x + 4, self.y + self.offset + 4, CARD_WIDTH, CARD_HEIGHT, 4)
    love.graphics.setColor(22/255, 22/255, 26/255)
    love.graphics.rectangle("fill", self.x, self.y + self.offset, CARD_WIDTH, CARD_HEIGHT, 4)

    -- icon
    love.graphics.setColor(1, 1, 1)
    self.kind.sheet:draw(self.x + CARD_WIDTH/2, self.y + self.offset + CARD_HEIGHT/2 - 40, 0.5, 0.5)

    -- text
    love.graphics.setFont(assets.font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.kind.desc, self.x + 10, self.y + self.offset + 80, CARD_WIDTH - 20, "center")
end

return Card