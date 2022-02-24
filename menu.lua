-- Questo rappresenta la schermata di menu 

-- carico la libreria composer e la metto in una variabile 
local composer = require( "composer" )
 
local scene = composer.newScene()

--funzione che serve per accedere alla schermata del gioco 
local function gotoGame()
    local gameTransition = {
          effect = "fade",
	      time = 500,
   }
    
    composer.gotoScene( "game", gameTransition)
end

-- funzioni degli eventi delle scene 

-- creiamo la scene
function scene:create( event )
     -- parte quando la scena e' creata ma non ancora visualizzata 
     local sceneGroup = self.view
	 --aggiungiamo la grafica al menu
	 
	 --background
	 local background = display.newImageRect(sceneGroup,"img/background.png",display.contentWidth,display.contentHeight)
	 background.x = display.contentCenterX
	 background.y = display.contentCenterY
	 --titolo
	 local title = display.newImage(sceneGroup,"img/title.png", 700, 250) 
	 title.x = display.contentCenterX
	 title.y = 100
	 
	 --bottono play
	 local playButton = display.newText(sceneGroup,"Play", display.contentCenterX,225, native.systemFont,50)
	 playButton:setFillColor( 1,1,1)
	 -- bottono punteggi
	 local backgroundMusic = audio.loadStream("sounds/backgroundMusic.mp3")
	 audio.play(backgroundMusic,{loops = -1, channel = 1 })
	 audio.setVolume( 0.60, { channel= 1 } )

	playButton:addEventListener( "tap", gotoGame )
end 

-- mostriamo la scena
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
    -- parte quando la scena non e ancora nello schermo ma sta per apparire 
	if ( phase == "will" ) then	 	
    -- parte quando la scena e' completamente nello schermo 
	elseif ( phase == "did" ) then	
	end
end


-- nascondo la scena 
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase
    -- parte quando la scena sta per scomparire dalla schermo 
	if ( phase == "will" ) then
    -- parte quando la scena e' uscita interamente dallo schermo 
	elseif ( phase == "did" ) then
	end
end


-- rimuovo la scena 
function scene:destroy( event )
    
	local sceneGroup = self.view

end


-- -----------------------------------------------------------------------------------
-- collego gli ascoltatori alle scene 
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene

	 




