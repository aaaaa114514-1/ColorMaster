-- ColorMaster - Color Recognition Game
-- Using the LÖVE engine

local Game = {
    targetColor = {0, 0, 0},     -- Target color (RGB)
    inputText = "",              -- Player's input text
    score = 0,                   -- Current round score
    showResult = false,          -- Whether to show results
    cursorVisible = true,        -- Cursor visibility state
    cursorTimer = 0,              -- Cursor blink timer
    inputActive = true,          -- Whether input is active
    gameStatus = "playing",      -- Game state
    rounds = 0                   -- Completed rounds
}

function love.load()
    love.window.setTitle("ColorMaster")
    love.window.setMode(800, 600, {
        resizable = false,
        vsync = true
    })
    
    -- Generate random target color
    generateNewColor()
    
    -- Set fonts
    Game.font = love.graphics.newFont(20)
    Game.titleFont = love.graphics.newFont(28)
    love.graphics.setFont(Game.font)
end

function love.update(dt)
    -- Update cursor blink effect
    Game.cursorTimer = Game.cursorTimer + dt
    if Game.cursorTimer > 0.5 then
        Game.cursorVisible = not Game.cursorVisible
        Game.cursorTimer = 0
    end
end

function love.draw()
    -- Draw background
    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    -- Draw title
    love.graphics.setFont(Game.titleFont)
    love.graphics.setColor(0.3, 0.7, 1)
    love.graphics.print("ColorMaster", 320, 25)
    love.graphics.setFont(Game.font)
    
    -- Draw instructions
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("Guess the HEX value of the center color", 200, 80)
    love.graphics.print("Example: #FFCC00", 280, 110)
    
    -- Draw the central color block
    drawColorBlock(250, 150, 300, 200, Game.targetColor)
    
    -- Draw input field
    drawInputField()
    
    -- Draw submit button
    drawSubmitButton()
    
    -- Draw results if applicable
    if Game.showResult then
        drawResult()
    end
    
    -- Draw round count
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("Rounds: " .. Game.rounds, 600, 570)
    
    -- Draw game state message
    if Game.gameStatus == "result" then
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.print("Press SPACE to continue", 280, 530)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
        return
    end
    
    -- Handle backspace
    if key == "backspace" then
        Game.inputText = string.sub(Game.inputText, 1, -2)
    
    -- Submit answer
    elseif key == "return" or key == "enter" then
        submitAnswer()
    
    -- Start next round with space
    elseif key == "space" and Game.gameStatus == "result" then
        startNewRound()
    
    -- Allow # symbol
    elseif key == "#" then
        if #Game.inputText < 7 then
            Game.inputText = Game.inputText .. "#"
        end
    end
end

function love.textinput(text)
    if not Game.inputActive or Game.gameStatus == "result" then
        return
    end
    
    -- Allow only hex characters (0-9, A-F, a-f) and # symbol
    local validChars = "0123456789ABCDEFabcdef#"
    if string.find(validChars, text) and #Game.inputText < 7 then
        Game.inputText = Game.inputText .. text
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        -- Check for submit button click
        if x > 335 and x < 465 and y > 440 and y < 480 then
            submitAnswer()
        end
        
        -- Click on input field to activate input
        if x > 240 and x < 560 and y > 380 and y < 420 then
            Game.inputActive = true
        else
            Game.inputActive = false
        end
    end
end

-- Generate new random color
function generateNewColor()
    math.randomseed(os.time())
    Game.targetColor[1] = math.random(0, 255)
    Game.targetColor[2] = math.random(0, 255)
    Game.targetColor[3] = math.random(0, 255)
    Game.showResult = false
    Game.inputText = ""
    Game.inputActive = true
end

-- Draw color block
function drawColorBlock(x, y, width, height, color)
    love.graphics.setColor(color[1]/255, color[2]/255, color[3]/255)
    love.graphics.rectangle("fill", x, y, width, height)
    
    -- Draw border
    love.graphics.setColor(0.9, 0.9, 0.9, 0.5)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", x, y, width, height)
    love.graphics.setLineWidth(1)
end

-- Draw input field
function drawInputField()
    -- Draw input field background
    love.graphics.setColor(0.25, 0.25, 0.25)
    love.graphics.rectangle("fill", 240, 380, 320, 40)
    
    -- Highlight border if active
    if Game.inputActive and Game.gameStatus == "playing" then
        love.graphics.setColor(0, 0.75, 1)
    else
        love.graphics.setColor(0.4, 0.4, 0.4)
    end
    
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 240, 380, 320, 40)
    
    -- Draw input text
    love.graphics.setColor(1, 1, 1)
    local displayText = Game.inputText
    
    -- Add # prefix hint
    if displayText == "" then
        displayText = "#"
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    
    love.graphics.printf(displayText, 250, 385, 300, "left")
    
    -- Draw cursor
    if Game.inputActive and Game.cursorVisible and Game.gameStatus == "playing" then
        local textWidth = Game.font:getWidth(displayText)
        love.graphics.setLineWidth(2)
        love.graphics.line(250 + textWidth, 385, 250 + textWidth, 415)
    end
end

-- Draw submit button
function drawSubmitButton()
    if Game.gameStatus == "playing" then
        love.graphics.setColor(0.2, 0.6, 0.2)
    else
        love.graphics.setColor(0.4, 0.4, 0.4)
    end
    
    love.graphics.rectangle("fill", 335, 440, 130, 40, 5)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("SUBMIT", 335, 450, 130, "center")
    
    -- Draw hint
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("or press ENTER to submit", 280, 490)
end

-- Submit answer
function submitAnswer()
    if Game.inputText == "" or Game.gameStatus ~= "playing" then
        return
    end
    
    -- Format input text (uppercase and ensure # prefix)
    local inputHex = Game.inputText
    if not inputHex:find("#") then
        inputHex = "#" .. inputHex
    end
    inputHex = inputHex:sub(1, 7):upper()
    
    -- Calculate score
    Game.score = calculateColorSimilarity(inputHex)
    Game.showResult = true
    Game.inputActive = false
    Game.gameStatus = "result"
    
    -- Increase round count
    Game.rounds = Game.rounds + 1
end

-- Calculate color similarity
function calculateColorSimilarity(inputHex)
    -- Validate hex format
    if not inputHex:match("^#[0-9A-F][0-9A-F][0-9A-F][0-9A-F]?[0-9A-F]?[0-9A-F]?$") then
        return 0
    end
    
    -- Extract input RGB
    local r1 = tonumber(inputHex:sub(2, 3), 16) or 0
    local g1 = tonumber(inputHex:sub(4, 5), 16) or 0
    local b1 = tonumber(inputHex:sub(6, 7), 16) or 0
    
    -- Target color
    local r2, g2, b2 = Game.targetColor[1], Game.targetColor[2], Game.targetColor[3]
    
    -- Calculate RGB difference percentage
    local rDiff = math.abs(r1 - r2) / 255
    local gDiff = math.abs(g1 - g2) / 255
    local bDiff = math.abs(b1 - b2) / 255
    
    -- Calculate similarity score (percentage)
    local diffScore = (rDiff + gDiff + bDiff) / 3
    local similarity = math.floor((1 - diffScore) * 100)
    
    -- Ensure score between 0-100
    return math.max(0, math.min(100, similarity))
end

-- Draw results
function drawResult()
    -- Get target color hex representation
    local targetHex = string.format("#%02X%02X%02X", 
        Game.targetColor[1], 
        Game.targetColor[2], 
        Game.targetColor[3])
    
    -- Draw result box
    love.graphics.setColor(0.1, 0.1, 0.2)
    love.graphics.rectangle("fill", 150, 380, 500, 130, 10)
    
    -- Draw border
    love.graphics.setColor(0, 0.5, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", 150, 380, 500, 130, 10)
    
    -- Draw result text
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.print("RESULT", 380, 395)
    
    love.graphics.setColor(0.8, 0.8, 1)
    love.graphics.print("Correct answer: " .. targetHex, 220, 430)
    
    -- Set score color based on performance
    if Game.score > 85 then
        love.graphics.setColor(0, 1, 0)        -- Green
    elseif Game.score > 70 then
        love.graphics.setColor(0.8, 0.8, 0)   -- Yellow
    elseif Game.score > 50 then
        love.graphics.setColor(1, 0.5, 0)     -- Orange
    else
        love.graphics.setColor(1, 0.2, 0)     -- Red
    end
    
    love.graphics.print("Score: " .. Game.score, 220, 460)
end

-- Start new round
function startNewRound()
    generateNewColor()
    Game.gameStatus = "playing"
end