-- Copyright 2024 Elloramir.
-- All rights over the code are reserved.

local level = {}

level.gen_id = 0

function level.load()
	level.gen_id = level.gen_id + 1
	level.entities = {}
	level.player = level.add_entity("player", 100, 100)

	level.add_entity("hud")
	level.add_entity("casette")
	level.add_entity("lifebar")

	for i = 1, 20 do
		-- place random enemies and obstacles
		if math.random() > 0.7 then
			level.add_entity("obstacle")
		else
			-- same but outside the screen
			local x = math.random(-WIDTH, WIDTH*2)
			local y = math.random(-HEIGHT, HEIGHT*2)

			level.add_entity("enemy", x, y)
		end
	end
end

function level.add_entity(name, ...)
	local en = require("entities."..name)(...)
	-- the assert is necessary to check if the entity
	-- the entity constructor has been called.
	assert(en.active)
	en.gen_id = level.gen_id
	table.insert(level.entities, en)
	return en
end

local function sort_entities(a, b)
	-- -- y sort is a property from "Sprite" class
	-- -- so consider it a class cast and then check.
	-- if a.y_sort and b.y_sort then
	-- 	return (a.y + a.order) < (b.y + b.order)
	-- end

	return a.order < b.order
end

function level.update(dt)
	-- loop entities in reverse order so we can remove them
	-- without indexing issues
	for i = #level.entities, 1, -1 do
		local en = level.entities[i]
		if en and en.active then
			if en.enabled and en.gen_id == level.gen_id then
				en:update(dt)
			end
		else
			table.remove(level.entities, i)
		end
	end

	table.sort(level.entities, sort_entities)
end

function level.draw()
	for _, en in ipairs(level.entities) do
		if en.active then en:draw() end
	end
end

function level.debug()
	for _, en in ipairs(level.entities) do
		if en.active then en:debug_draw() end
	end
end

return level
