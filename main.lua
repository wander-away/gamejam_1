require "enemy"

buttons = {}
local font = nil

-- function for setting up new button, requires a text and function variable in the parameters
function newButton(text, fn)
  return {
    text = text,
    fn = fn,

		now = false,
		last = false
  }
end

-- Love2d callback function for loading in game, called once when game is loaded
function love.load()
  -- initalizes player table
	player = {}
  -- player variables
	player.x = 465
	player.y = 450
	player.w = 30
	player.h = 30
	player.speed = 300
	player.bullets = {}

  -- player shot variable, is a boolean and is a flag to know if player has shot
  playerShot = false

  -- initializes player image and background variables
	playerImg = love.graphics.newImage('assets/images/player2.png')
	background = love.graphics.newImage('assets/images/sea2.png')

  -- score variable to keep track of the player's score
	score = 0

  -- paused boolean variable
	paused = false

  -- boolean variable to flag if need to switch over to game over screen
	drawGameOver = false

  -- initalizes sounds and music variables
  music = love.audio.newSource('assets/sounds/classicalmusic.mp3', 'stream')
  bulletSound = love.audio.newSource('assets/sounds/fireballsound.wav', 'static')
  enemyHit = love.audio.newSource('assets/sounds/enemyHit.wav', 'static')

  -- initalizes game state to a start state, this is a primitive state machine and it is useful so we can switch between states of the game.
	gameState = "startState"

  -- if the game state is equal to string start states then create buttons for main menu
	if gameState == "startState" then
    -- font variable to set a font to use for the buttons
		font = love.graphics.newFont(32)
    -- lua function to insert into a 'buttons' table and inserts the newButton function, Has 3 buttons, 'Start Game', 'Settings', 'Exit'
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

-- LOVE2D's update function, this is called every frame which is 1/60th of a second as the frames per second (FPS) is set to 60
function love.update(dt)
  -- asks if the paused variable is set to false, if it is then asks if the game state is the play state
	if paused == false then
		if gameState == 'playState' then
      -- function callbacks for the bulletcollision and enemy update function
			bulletCollision()
			enemy:update(dt)

      -- sets the music to loop, sets the volume (as if left to full volume (1.0) then it is too loud, and uses play function provided by LOVE2D
      music:setLooping(true)
      music:setVolume(0.7)
      music:play()

      -- uses LOVE2D's keyboard functions and asks if the 'left' arrow key is down and if is set player's x to player's x - the speed of the player times by deltatime (FPS) and then vice versa
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

      -- for loop that indexs through the player.bullets table and sets the velocity of the bullets
			for i,v in ipairs(player.bullets) do
				v.y = v.y - 1000 * dt

        -- if the y velocity (<-speed) is less than or equal to -2 then remove the bullet from the table
				if v.y <= -2 then
					table.remove(player.bullets, i)
				end
			end

      -- if a enemy contacts the ground then it adds one to the groundContacts variable, if it reaches 5 then call the gameOver function which switches to gameOver state and draws the gameover screen
			if groundContacts == 5 then
				gameOver()
			end
		end
	end
end

-- LOVE2D's draw function, it is also called every second as the same as love.update function but is only used to draw onto the screen
function love.draw()
	if gameState == 'startState' then
    -- prints the parameters at ("string", x, y)
		love.graphics.print("Welcome to the game!", 300, 40)

    -- sets local variables window width (ww), and window height (wh) to the width and height of the screen using love graphics functions
		local ww = love.graphics.getWidth()
		local wh = love.graphics.getHeight()

    -- sets local variables for the button width and height and the margin for which the buttons are seperated so they are not touching
		local button_width = ww * (1/3)
		local BUTTON_HEIGHT = wh * (1/8)
		local margin = 16

    -- sets a total height variable for the buttons and a y cursor variable 
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
    music:stop()
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end

	if key == "space" then
    bulletSound:play()
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
  -- for loop index, value in table enemy
	for i,v in ipairs(enemy) do
		for ia, va in ipairs(player.bullets) do
			if va.x + 4 > v.x and
			va.x < v.x + 32 and
			va.y + 4 > v.y and
			va.y < v.y + 32 then
				score = score + 1
        enemyHit:play()
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
