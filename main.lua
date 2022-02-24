-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

-- carico la libreria composer e la metto in una variabile 
local composer = require( "composer" )

-- Nascondo la status bar 
display.setStatusBar( display.HiddenStatusBar )
 

 -- Metto un seme causare per random math cosi che ogni volta che avvio il gioco avro un seme diverso
 -- di numeri casuali
 
math.randomseed( os.time() )


-- vado alla shermata menu 
local options = {
    effect = "fade",
	time = 1000,
   }
composer.gotoScene( "crediti" , options )




