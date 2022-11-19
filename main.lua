local Car = require( "car" )

local ground = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
ground:setFillColor( 0.5, 0.5, 0.5 )

local car1 = Car.new
{
    x = math.random( 100, display.contentWidth - 100 ),
    y = math.random( 100, display.contentHeight - 100 ),
    rotation = math.random( 360 )
}

local enterFrame = function( event )
    car1.update()
end
