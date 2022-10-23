-- enemy class
enemy = {}
enemy.w = 30
enemy.h = 30
enemy.timer = 0
enemy.timerLimit = 1

-- variable to keep count of how many enemies have touched the ground
groundContacts = 0

-- empty enemy load function
function enemy:load()
end

-- enemy update function
function enemy:update(dt)
	-- spawn function callback for enemy spawns
	enemy:spawn(dt)

	-- loops through enemy table and depending on their color the speed changes
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

		-- if the y is below 510 then change alive function to false
		if v.y >= 510 then
			v.alive = false
		end

		-- if enemy alive is false (dead) then add 1 to ground contacts and remove it from enemy table
		if v.alive == false then
			groundContacts = groundContacts + 1
			table.remove(enemy, i)
		end
	end
end

-- enemy draw function
function enemy:draw()
	-- loops through enemy table and depending on color variable, sets the color and draws it
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

-- enemy spawn function takes in dt, x, y, color, and alive as parameters
function enemy:spawn(dt, x, y, color, alive)
	-- basic timer variable
	enemy.timer = enemy.timer + dt
	-- when timer variable reaches timer limit which is (1) then insert a new enemy into table
	if enemy.timer >= enemy.timerLimit then
		-- random x spawn, enemy's y is -height, color is randomized between 1 and 3, and alive is set to true
		table.insert(enemy, {x = love.math.random(0, 700), y = -enemy.h, color = love.math.random(1, 3), alive = true})
		-- reset timer
		enemy.timer = 0
	end
end
