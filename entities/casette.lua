-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local tick = require("tick")
local flux = require("flux")
local assets = require("assets")
local Entity = require("entity")
local Casette = Entity:extend()

local current_music_index = 0

function Casette:new(x, y)
    Casette.super.new(self)
    self:set_order(ORDER_UI)

    self.title = ""
    self:choose_music()
end

function Casette:choose_music()
    current_music_index = (current_music_index + 1) % #assets.music_setlist
    local choose = assets.music_setlist[current_music_index]
    
    self.title = choose[1]
    self.playing = choose[2]

    self:casette_animation()
    assets.sfx_casette_switch:play()
    self.will_play = tick.delay(function()
        self.will_play = nil
        self.playing:play()
        self.playing:setVolume(0.5)
    end, 1.3)
end

function Casette:casette_animation()
    self.casette_offset = 50
    self.tween = flux.to(self, 0.75, {casette_offset = 0})
        :ease("backout")
end

function Casette:update(dt)
    if not self.playing:isPlaying() and not self.will_play then
        self:choose_music()
    end
end

function Casette:post_draw()
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
        local tw = font:getWidth(self.title)
        local th = font:getHeight()

        local x = WIDTH - 25 - assets.casette.width - tw + self.casette_offset
        local y = HEIGHT - 10 - assets.casette.height/2 - th/2

        -- wooble animation
        local angle = math.sin(self.casette_offset * 0.1) * 0.3

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(self.title, x, y, tw, "right", angle)
    end
end

return Casette