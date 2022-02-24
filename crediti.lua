local composer = require( "composer" )

local scene = composer.newScene()

local function gotoMenu()
     
    composer.gotoScene( "menu", "fade")
end
-- create()
function scene:create( event )

	local sceneGroup = self.view
	
	local background = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY, display.contentWidth, display.contentHeight)
    background:setFillColor(1,1,1) 
	
	local logoStm = display.newImageRect(sceneGroup,"img/logoStm.png",300,300)
	logoStm.x = display.contentCenterX
	logoStm.y = display.contentCenterY
	
	local timer = timer.performWithDelay(3000,gotoMenu,1)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		

	elseif ( phase == "did" ) then
		

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		

	elseif ( phase == "did" ) then
		

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	

end



scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene