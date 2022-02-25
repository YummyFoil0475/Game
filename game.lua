--Schermata in game 

-- carico la libreria composer e la metto in una variabile 
local composer = require( "composer" )
 
local scene = composer.newScene()

--richiamo la fisica tramite la libreria physics 
local physics = require("physics")
physics.setDrawMode("normal")
physics.start()
physics.pause()

--tabella contenente la lista dei vari virus generati 
local virusTable = {}
local oxygen_cell
local score 
local scoreText
local timergameLoop
local background
local background2
local bottom_wall
local bottom_wall2
local top_wall
local top_wall2
local scoreFinaleTxt
local highScore
local highScoreTxt
local menubutton
local go
local sceneGroup


--FUNZIONI 
--creiamo la funzione per generare in una posizione random a destra fuori dallo schermo un virus 
local function createVirus()
      local virus 
      virus = display.newImageRect(sceneGroup,"img/virus.png",87,87)
      virus.x = display.contentWidth+math.random(300)
      virus.y = math.random(37+48.5,display.contentHeight-95)
      virus.speed = 2 
      virus.speed = virus.speed +0.01
      virus.angle= math.random(360)
      virus.amp = 0.5
      virus.addedScore = false 
      physics.addBody(virus,"static",{bounce= 0.0, radius=87/2})          
      table.insert(virusTable,virus)
      return virus
end 


--funzione per lo scrolling dei virus e un leggere movimento ondulatorio  
local function virusScroll(self,event)
    self.x = self.x -self.speed
    self.angle = self.angle + 0.1
    self.y = self.y +self.amp*math.sin(self.angle)
    
    if (self.x < oxygen_cell.x and self.addedScore==false ) then 
        self.addedScore = true 
        score = score + 1 
        scoreText.text = "Score: "..score
        scoreFinaleTxt.text = "FinalScore: "..score 
        if score >= highScore then 
            highScore = score 
            highScoreTxt.text= "HighScore: "..highScore
        end 
    end
end     


--creiamo una funzione loop e cancellazione dei virus non più utili  
local function gameLoop()
   local virus = createVirus()
   virus.enterFrame = virusScroll
   Runtime:addEventListener("enterFrame",virus)
   print(#virusTable .. " virus on screen")
   for i,thisVirus in pairs(virusTable) do 
       if thisVirus.x < -116 then 
          Runtime:removeEventListener("enterFrame", thisVirus)
          display.remove(thisVirus)
          table.remove(virusTable,i)
        end 
   end 
end

--funzione che scrive nel file l'highscore 
local function updateHighScore()
    
        local path = system.pathForFile( "highScore.txt", system.DocumentsDirectory )
        local file, errorString = io.open( path, "w" )
        if not file then
            print( "File error: " .. errorString )
        else
            file:write( score )
            io.close( file )
        end 
        file = nil  
end

local function removeAllListeners()
    --elimina gli ascoltatori per lo scrollling del terreno e del soffito
    Runtime:removeEventListener("enterFrame",background)
    Runtime:removeEventListener("enterFrame",background2)
    Runtime:removeEventListener("enterFrame",top_wall)
    Runtime:removeEventListener("enterFrame",top_wall2) 
    Runtime:removeEventListener("enterFrame",bottom_wall)
    Runtime:removeEventListener("enterFrame",bottom_wall2)
    for i,thisVirus in pairs(virusTable) do
      Runtime:removeEventListener("enterFrame", thisVirus)
      display.remove(thisVirus)
    end
    if oxygen_cell ~= nil then
        Runtime:removeEventListener("collision",oxygen_cell)
    end
end

--funzione gameover 
local function gameOver(event)
    if score == highScore then
          updateHighScore()
    end
    timer.cancel(timergameLoop)
    scoreFinaleTxt.isVisible = true 
    highScoreTxt.isVisible = true
    go.isVisible= true
    menubutton.isVisible = true         
    physics.pause()
    removeAllListeners()
    for k = 1, #virusTable do
        if virusTable[k] ~= nil then
            table.remove(virusTable, k)
        end
    end
    menubutton:addEventListener("tap", function()
        composer.gotoScene( "menu" , "fade" )
    end)

end 

--funzione che gestisce la collisione che porta al gameover 
local function onCellCollision(self,event) 

    if (event.phase =="began") then 
      audio.pause(backgroundMusicGame)
      Runtime:removeEventListener("touch", touch)
      gameOver()
    elseif event.phase=="ended" then        
    end 
    return true 
end     


--creiamo la funzione touch per far saltare la cellula 
 local function touch(event) 
    if event.phase =="began" then 
       oxygen_cell:applyLinearImpulse(0,-0.2 , oxygen_cell.x, oxygen_cell.y)
    end 
end 

    
--creo funzione dello scorrimento delle pareti 
local function scollerPareti(self, event)
       local speed = 3 
       if self.x <- (display.contentWidth-speed*2) then
       self.x = display.contentWidth
       else
       self.x = self.x - speed
       end 
end

-- creiamo la funzione per lo scorrimento dello sfondo 
local function scroller (self, event)
       local speed = 1 
       if self.x <- (display.contentWidth-speed*2) then
       self.x = display.contentWidth
       else
       self.x = self.x - speed
       end 
end 

--creiamo la scena e carichiamo i vari elementi 
function scene:create( event ) 
     
     sceneGroup = self.view

     --CARICHIAMO LA GRAFICA 
     --sfondo
     background = display.newImageRect(sceneGroup,"img/background.png",display.contentWidth,display.contentHeight )
     background.anchorX = 0
     background.anchorY = 0
     background.x = 0
     background.y = 0
     --sfondo 2 che servira per l'effetto scrolling 
    background2 = display.newImageRect(sceneGroup,"img/background2.png", display.contentWidth,display.contentHeight)
    background2.anchorX = 0
    background2.anchorY = 0
    background2.x = display.contentWidth
    background2.y = 0
    --carico la parete inferiore 
    bottom_wall = display.newImageRect(sceneGroup,"img/bottom_wall.png",1280,37)
    bottom_wall.anchorX = 0
    bottom_wall.anchorY = 37
    bottom_wall.x = 0
    bottom_wall.y = display.contentHeight
    physics.addBody(bottom_wall, "static",{bounce = 0.0})
    --carico parete inferiore 2 per l'effetto di scrolling
    bottom_wall2 = display.newImageRect(sceneGroup,"img/bottom_wall2.png",1280,37)
    bottom_wall2.anchorX = 0
    bottom_wall2.anchorY = 37
    bottom_wall2.x = display.contentWidth
    bottom_wall2.y = display.contentHeight
    physics.addBody(bottom_wall2, "static",{bounce = 0.0})
    --carico parete superiore 
    top_wall = display.newImageRect(sceneGroup,"img/top_wall.png",1280,37)
    top_wall.anchorX = 0
    top_wall.anchorY = 0
    top_wall.x = 0
    top_wall.y = 0
    physics.addBody(top_wall, "static",{bounce = 0.0})
    --carico la parete superiore 2 per l'effetto di scrolling
    top_wall2 = display.newImageRect(sceneGroup,"img/top_wall2.png",1280,37)
    top_wall2.anchorX = 0
    top_wall2.anchorY = 0
    top_wall2.x = display.contentWidth
    top_wall2.y = 0
    physics.addBody(top_wall2,"static",{bounce = 0.0})
    -- visualizzo lo score 
    score = 0 
    scoreText = display.newText(sceneGroup, "Score: "..score,20,20, nativeSystemFont, 30)
    scoreText.anchorX = 0
    scoreText.anchorY = 0
    scoreText:setFillColor(1,1,1)
    
    --score finale della run  
    scoreFinaleTxt = display.newText(sceneGroup, "FinalScore: "..score, display.contentCenterX, display.contentCenterY-25 , nativeSystemFont, 40)
    scoreFinaleTxt:setFillColor(1,1,1)
    scoreFinaleTxt.isVisible = false    
    
    --HighScore
    highScore = 0
    highScoreTxt = display.newText(sceneGroup, "HighScore: "..highScore, display.contentCenterX, display.contentCenterY+50, nativeSystemFont, 60) 
    highScoreTxt:setFillColor(1,1,1)
    highScoreTxt.isVisible = false  
    
    --bottono per tornare al menu dopo aver perso 
    menubutton = display.newText(sceneGroup, "Menu",display.contentCenterX, display.contentCenterY+150, nativeSystemFont, 40)     
          menubutton.isVisible = false 
    
    --scritta game over     
    go = display.newImageRect(sceneGroup,"img/gameover.png",509,81)
          go.x = display.contentCenterX
          go.y = display.contentCenterY-100
          go.isVisible= false 
    
    
    --carico la cellula di sangue che poi nel gioco noi controlleremo
    oxygen_cell = display.newImageRect(sceneGroup ,"img/oxygen_cell.png",57,57)
    oxygen_cell.x = 100
    oxygen_cell.y = display.contentHeight/2
    physics.addBody(oxygen_cell, "dynamic",{bounce = 0, radius = 57/2} )

    oxygen_cell.collision = onCellCollision
    oxygen_cell:addEventListener("collision",oxygen_cell)
        
end 

function scene:show( event )
    local phase = event.phase
    -- parte quando la scena non e ancora nello schermo ma sta per apparire 
    if ( phase == "will" ) then
        score = 0
        scoreFinaleTxt.isVisible = false 
        highScoreTxt.isVisible = false
        go.isVisible= false
        menubutton.isVisible = false
        oxygen_cell.x = 100
        oxygen_cell.y = display.contentHeight/2
        oxygen_cell:setLinearVelocity( 0, 0 )
        scoreText.text = "Score: 0"
        scoreFinaleTxt.text = "FinalScore: 0" 
        -- parte quando la scena e' completamente nello schermo 
    elseif ( phase == "did" ) then
        physics.start()
        Runtime:addEventListener("touch", touch)

        -- aggiungiamo una varibile che richiama il game loop ogni tot tempo, deciso da me 
        timergameLoop = timer.performWithDelay(4000,gameLoop,0)

        -- collego le due variabili all'ascoltatore 
        background.enterFrame = scroller 
        Runtime:addEventListener("enterFrame", background)

        background2.enterFrame = scroller
        Runtime:addEventListener("enterFrame", background2) 
        
        top_wall.enterFrame = scollerPareti
        Runtime:addEventListener("enterFrame",top_wall)
        
        top_wall2.enterFrame = scollerPareti
        Runtime:addEventListener("enterFrame",top_wall2)
        
        bottom_wall.enterFrame = scollerPareti
        Runtime:addEventListener("enterFrame", bottom_wall)
        
        bottom_wall2.enterFrame = scollerPareti
        Runtime:addEventListener("enterFrame", bottom_wall2)
    end
end

function scene:hide( event )
    local phase = event.phase
 
    if ( phase == "will" ) then

        physics.pause()
        Runtime:removeEventListener("touch", touch)

        if timergameLoop ~= nil then
            timer.cancel(timergameLoop)
        end
        removeAllListeners()
 
    elseif ( phase == "did" ) then
        --audio.pause(backgroundMusicGame)
    end
end

function scene:destroy( event )
    display.remove(sceneGroup)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )



return scene