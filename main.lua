require "enemy"

buttons = {}
local font = nil

function newButton(text, fn)
  return {
    text = text,
    fn = fn,

		now = false,
		last = false
  }
end

function love.load()
	player = {}
	player.x = 465
	player.y = 450
	player.w = 30
	player.h = 30
	player.speed = 300
	player.bullets = {}

	playerImg = love.graphics.newImage('player2.png')
	background = love.graphics.newImage('sea2.png')

	devConsole = false

	score = 0

	paused = false

	drawGameOver = false

	gameState = "startState"

	if gameState == "startState" then
		font = love.graphics.newFont(32)
		table.insert(buttons, newButton(
			"Start Game",
			function()
				print("Starting Game")
				gameState = "playState"
			end))
		table.insert(buttons, newButton(
			"Settings",
			function()
				print("Settings")
				gameState = "settingsState"
			end))
		table.insert(buttons, newButton(
			"Exit",
			function()
				love.event.quit(0)
			end))
	end
end

function love.update(dt)
	if paused == false then
		if gameState == 'playState' then
			bulletCollision()
			enemy:update(dt)

			if love.keyboard.isDown("left") then
				player.x = player.x - player.speed * dt
			end
			if love.keyboard.isDown("right") then
				player.x = player.x + player.speed * dt
			end

			-- keep player in bounds of screen by checking if x is greater than or less than window_width - 30 or 0
			if player.x >= 690 then
				player.x = 690
			end
			if player.x <= 0 then
				player.x = 0
			end

			for i,v in ipairs(player.bullets) do
				v.y = v.y - 1000 * dt

				if v.y <= -2 then
					table.remove(player.bullets, i)
				end
			end

			if groundContacts == 5 then
				gameOver()
			end
		end
	end
end

function love.draw()
	if gameState == 'startState' then
		love.graphics.print("Welcome to the game!", 300, 240)

		local ww = love.graphics.getWidth()
		local wh = love.graphics.getHeight()

		local button_width = ww * (1/3)
		local BUTTON_HEIGHT = wh * (1/8)
		local margin = 16

		local total_height = (BUTTON_HEIGHT + margin) * #buttons
		local cursor_y = 0

		for i, button in ipairs(buttons) do
			button.last = button.now

			local bx = (ww * 0.5) - (button_width * 0.5)
			local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

			local color = {0.4, 0.4, 0.5, 1.0}
			local mx, my = love.mouse.getPosition()

			local hot = mx > bx and mx < bx + button_width and
									my > by and my < by + BUTTON_HEIGHT

			if hot then
				color = {0.8, 0.8, 0.9, 1.0}
			end

			button.now = love.mouse.isDown(1)
			if button.now and not button.last and hot then
				button.fn()
			end

			love.graphics.setColor(unpack(color))
			love.graphics.rectangle(
				"fill",
				bx,
				by,
				button_width,
				BUTTON_HEIGHT
		)

			love.graphics.setColor(0, 0, 0, 1)

			local textW = font:getWidth(button.text)
			local textH = font:getHeight(button.text)

			love.graphics.print(
				button.text,
				font,
				(ww * 0.5) - textW * 0.5,
				by + textH * 0.5
		)

			cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
		end

	end



	if gameState == 'playState' then
		love.graphics.push()
		love.graphics.scale(7, 7)
		love.graphics.draw(background)
		love.graphics.pop()

		enemy:draw()

		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(playerImg, player.x, player.y, 0, 2, 2)

		love.graphics.setColor(1, 0, 0)
		for i,v in ipairs(player.bullets) do
			--love.graphics.rectangle("fill", v.x, v.y, 10, 10)
			love.graphics.circle("fill", v.x, v.y, 9)
		end

		love.graphics.setColor(1, 1, 1)
		love.graphics.print("score: "..tostring(score), 10, 10)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("enemies landed = "..tostring(groundContacts), 10, 25)
	end

	if gameState == 'gameOver' then
		love.graphics.print("Game over!", 300, 240)
		love.graphics.print("Final Score: "..tostring(score), 300, 260)
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end

	if key == "space" then
		shoot()
	end

	if key == "k" and devConsole == false then
		devConsole = true
	end
	if key == "l" and devConsole == true then
		devConsole = false
	end

	if key == "o" and paused == false then
		paused = true
	end
	if key == "p" and paused == true then
		paused = false
	end

	if key == "j" and gameState == "startState" then
		gameState = "playState"
	end
end

function shoot()
	if paused == false then
		if gameState == 'playState' then
			bullet = {}
			bullet.x = player.x + 13
			bullet.y = player.y - 4
			table.insert(player.bullets, bullet)
		end
	end
end

function bulletCollision()
	for i,v in ipairs(enemy) do
		for ia, va in ipairs(player.bullets) do
			if va.x + 4 > v.x and
			va.x < v.x + 32 and
			va.y + 4 > v.y and
			va.y < v.y + 32 then
				score = score + 1
				table.remove(enemy, i)
				table.remove(player.bullets, ia)
			end
		end
	end
end

function newButton(text, fn)
  return {
    text = text,
    fn = fn,
  }
end

function gameOver()
	paused = true
	drawGameOver = true
	gameState = 'gameOver'
end

function startState()
	gameState = "startState"
end
