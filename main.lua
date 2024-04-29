-- raycaster

local player = {
    x = 22,
    y = 12,
    angle = 0,
    fov = math.pi / 3,
    speed = 5,
    rotSpeed = 3
}

--[[ local map = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 1},
    {1, 0, 0, 0, 1, 1, 1, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
} ]]

-- make a maze (corridors are two wide)
local map = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 1, 3, 1, 0, 0, 1},
    {1, 0, 0, 0, 1, 0, 1, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1, 0, 0, 1},
    {1, 0, 0, 0, 1, 0, 1, 0, 0, 1},
    {1, 0, 0, 0, 4, 0, 1, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 0, 0, 0, 0, 1, 0, 0, 1},
    {1, 1, 1, 3, 0, 0, 3, 1, 1, 1},
    {1, 1, 1, 2, 0, 0, 2, 1, 1, 1},
    {1, 1, 1, 4, 0, 0, 4, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
}

local mouse_sensitive = 50

function love.load()
    love.window.setTitle("Raycaster")
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    -- set player pos to top left that isn't a wall
    for y = 1, #map do
        for x = 1, #map[y] do
            if map[y][x] == 0 then
                player.x = x - 0.5
                player.y = y - 0.5
                break
            end
        end
    end
    -- lock mouse to window
    love.mouse.setRelativeMode(true)
end

function love.update(dt)
    --[[ if love.keyboard.isDown("w") then
        player.x = player.x + math.cos(player.angle) * player.speed * dt
        player.y = player.y + math.sin(player.angle) * player.speed * dt
    end
    if love.keyboard.isDown("s") then
        player.x = player.x - math.cos(player.angle) * player.speed * dt
        player.y = player.y - math.sin(player.angle) * player.speed * dt
    end
    if love.keyboard.isDown("a") then
        player.angle = player.angle - player.rotSpeed * dt
    end
    if love.keyboard.isDown("d") then
        player.angle = player.angle + player.rotSpeed * dt
    end ]]
    -- above code, but checking for walls
    if love.keyboard.isDown("w") then
        local newX = player.x + math.cos(player.angle) * player.speed * dt
        local newY = player.y + math.sin(player.angle) * player.speed * dt
        if map[math.floor(newY) + 1] and map[math.floor(newY) + 1][math.floor(newX) + 1] == 0 then
            player.x = newX
            player.y = newY
        end
    end

    if love.keyboard.isDown("s") then
        local newX = player.x - math.cos(player.angle) * player.speed * dt
        local newY = player.y - math.sin(player.angle) * player.speed * dt
        if map[math.floor(newY) + 1] and map[math.floor(newY) + 1][math.floor(newX) + 1] == 0 then
            player.x = newX
            player.y = newY
        end
    end

    if love.keyboard.isDown("a") then
        local newX = player.x + math.cos(player.angle - math.pi / 2) * player.speed * dt
        local newY = player.y + math.sin(player.angle - math.pi / 2) * player.speed * dt
        if map[math.floor(newY) + 1] and map[math.floor(newY) + 1][math.floor(newX) + 1] == 0 then
            player.x = newX
            player.y = newY
        end
    end

    if love.keyboard.isDown("d") then
        local newX = player.x + math.cos(player.angle + math.pi / 2) * player.speed * dt
        local newY = player.y + math.sin(player.angle + math.pi / 2) * player.speed * dt
        if map[math.floor(newY) + 1] and map[math.floor(newY) + 1][math.floor(newX) + 1] == 0 then
            player.x = newX
            player.y = newY
        end
    end

    if love.keyboard.isDown("q") then
        player.angle = player.angle - player.rotSpeed * dt
    end
    if love.keyboard.isDown("e") then
        player.angle = player.angle + player.rotSpeed * dt
    end
end

function love.mousemoved(x, y, dx, dy)
    player.angle = player.angle + dx * (mouse_sensitive * 0.0001)
end

function love.draw()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local cellSize = 32
    local halfFov = player.fov / 2
    local numRays = w
    local angleStep = player.fov / numRays
    for i = 1, numRays do
        local rayAngle = player.angle - halfFov + i * angleStep
        local distanceToWall = 0
        local hitWall = false
        local eyeX = math.cos(rayAngle)
        local eyeY = math.sin(rayAngle)
        while not hitWall and distanceToWall < 16 do
            distanceToWall = distanceToWall + 0.1
            local testX = math.floor(player.x + eyeX * distanceToWall)
            local testY = math.floor(player.y + eyeY * distanceToWall)
            if map[testY+1] and map[testY+1][testX+1] then
                if map[testY + 1][testX + 1] ~= 0 then
                    hitWall = true
                    local blockMidX = testX + 0.5
                    local blockMidY = testY + 0.5
                    local testAngle = math.atan2(player.y - blockMidY, player.x - blockMidX)
                    local testAngle = testAngle - rayAngle
                    if testAngle > math.pi then
                        testAngle = testAngle - 2 * math.pi
                    end
                    if testAngle < -math.pi then
                        testAngle = testAngle + 2 * math.pi
                    end
                    distanceToWall = distanceToWall * math.cos(testAngle)
                    local ceiling = h / 2 - h / distanceToWall
                    local floor = h - ceiling
                    --[[ love.graphics.setColor(0.2, 0.2, 0.2)
                    love.graphics.line(i, 0, i, ceiling)
                    love.graphics.setColor(0.4, 0.4, 0.4)
                    love.graphics.line(i, ceiling, i, floor)
                    love.graphics.setColor(0.6, 0.6, 0.6)
                    love.graphics.line(i, floor, i, h) ]]
                    -- different colors for different walls
                    -- 1 = gray, 2 = red, 3 = green, 4 = blue
                    if map[testY + 1][testX + 1] == 1 then
                        love.graphics.setColor(0.25, 0.25, 0.25)
                    elseif map[testY + 1][testX + 1] == 2 then
                        love.graphics.setColor(1, 0, 0)
                    elseif map[testY + 1][testX + 1] == 3 then
                        love.graphics.setColor(0, 1, 0)
                    elseif map[testY + 1][testX + 1] == 4 then
                        love.graphics.setColor(0, 0, 1)
                    end
                    love.graphics.line(i, ceiling, i, floor)
                end
            end
        end
    end

    -- print FPS
    love.graphics.setColor(0, 0, 0)
    for x = -1, 1 do
        for y = -1, 1 do
            love.graphics.print(love.timer.getFPS(), x, y)
        end
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(love.timer.getFPS(), 0, 0)
end