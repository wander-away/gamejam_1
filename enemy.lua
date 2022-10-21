enemy = {}
enemy.w = 30
enemy.h = 30
enemy.timer = 0
enemy.timerLimit = 1

groundContacts = 0

function enemy:load()
end

function enemy:update(dt)
	enemy:spawn(dt)

	for i,v in ipairs(enemy) do
		if v.color == 1 then
			v.y = v.y + 100 * dt
		end
		if v.color == 2 then
			v.y = v.y + 50 * dt
		end
		if v.color == 3 then
			v.y = v.y + 25 * dt
		end

		if v.y >= 510 then
			v.alive = false
		end

		if v.alive == false then
			groundContacts = groundContacts + 1
			table.remove(enemy, i)
		end
	end
end

function enemy:draw()
	for i,v in ipairs(enemy) do
		if v.color == 1 then
			love.graphics.setColor(255, 0, 0)
			love.graphics.rectangle("fill", v.x, v.y, enemy.w, enemy.h)
		end
		if v.color == 2 then
			love.graphics.setColor(255, 255, 0)
			love.graphics.rectangle("fill", v.x, v.y, enemy.w, enemy.h)
		end
		if v.color == 3 then
			love.graphics.setColor(0, 255, 0)
			love.graphics.rectangle("fill", v.x, v.y, enemy.w, enemy.h)
		end
	end
end

function enemy:spawn(dt, x, y, color, alive)
	enemy.timer = enemy.timer + dt
	if enemy.timer >= enemy.timerLimit then
		table.insert(enemy, {x = love.math.random(0, 700), y = -enemy.h, color = love.math.random(1, 3), alive = true})
		enemy.timer = 0
	end
end
