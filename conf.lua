function love.conf(t)
	t.window.width = 720
	t.window.height = 480
end



--if devConsole == true then
--	love.graphics.setColor(1, 1, 1)
--	love.graphics.print("fps = "..tostring(love.timer.getFPS()), 10, 40)
--	love.graphics.setColor(1, 1, 1)
--	love.graphics.print("timer = "..tostring(enemy.timer), 10, 85)
--	love.graphics.setColor(1, 1, 1)
--	love.graphics.print("bullets in table = "..tostring(#player.bullets), 10, 55)
--	love.graphics.setColor(1, 1, 1)
--	love.graphics.print("enemies in table = "..tostring(#enemy), 10, 70)
--end

--if drawGameOver == true then
--	love.graphics.setColor(0, 0, 0)
--	love.graphics.rectangle("fill", 0, 0, 960, 540)

--	love.graphics.setColor(1, 1, 1)
--	love.graphics.print("GAME OVER", 330, 240)
--end
