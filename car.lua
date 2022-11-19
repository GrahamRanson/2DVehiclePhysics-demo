--- Required libraries.
local Controller = require( "2DVehiclePhysics.controller" )

--- Required libraries.

-- Localised functions.
local deg = math.deg

-- Localised values.

--- Class creation.
local Car = {}

--- Initiates a new Car object.
-- @return The new Car.
function Car.new( options )

	-- Create ourselves
	local self = display.newGroup()

    for k, v in pairs( options or {} ) do
        self[ k ] = v
    end

    self._keys = {}

	self.x0 = self.x or 0
	self.y0 = self.y or 0
	self.rotation0 = self.rotation or 0

	if self.world then
		self.world:insert( self )
	end

	self._controller = Controller.new
	{
		heading = math.rad( self.rotation0 or 0 ),
		position = { x = self.x0, y = self.y0 }
	}

	local scale = 7

	local bodyWidth, bodyHeight = ( self._controller.config.cgToFront + self._controller.config.cgToRear ) * scale, ( self._controller.config.halfWidth * 2.0 ) * scale
	self._body = display.newRect( self, 0, 0, bodyWidth, bodyHeight )

	self._window = display.newRect( self, bodyWidth * 0.5, 0, bodyHeight * 0.25, bodyWidth * 0.25 )
	self._window:setFillColor( 0, 0, 1 )

	local wheelWidth, wheelHeight = ( self._controller.config.wheelRadius * 2 ) * ( scale * 1.5 ), self._controller.config.wheelWidth * ( scale * 1.5 )
    self._wheels = {}
    self._wheels[ 1 ] = display.newRect( self, bodyWidth * 0.3, -bodyHeight * 0.5, wheelWidth, wheelHeight )
    self._wheels[ 1 ]:setFillColor( 1, 0, 0 )

    self._wheels[ 2 ] = display.newRect( self, bodyWidth * 0.3, bodyHeight * 0.5, wheelWidth, wheelHeight )
    self._wheels[ 2 ]:setFillColor( 1, 0, 0 )

    self._wheels[ 3 ] = display.newRect( self, -bodyWidth * 0.3, -bodyHeight * 0.5, wheelWidth, wheelHeight )
    self._wheels[ 3 ]:setFillColor( 1, 0, 0 )

    self._wheels[ 4 ] = display.newRect( self, -bodyWidth * 0.3, bodyHeight * 0.5, wheelWidth, wheelHeight )
    self._wheels[ 4 ]:setFillColor( 1, 0, 0 )

    function self.setThrottle( value )
        self._controller.inputs.throttle = value
    end

    function self.getThrottle()
        return self._controller.inputs.throttle
    end

    function self.setBrake( value )
        self._controller.inputs.brake = value
    end

    function self.getBrake()
        return self._controller.inputs.brake
    end

    function self.setHandbrake( value )
        self._controller.inputs.ebrake = value
    end

    function self.getHandbrake()
        return self._controller.inputs.ebrake
    end

    function self.setLeftSteering( value )
        self._controller.inputs.right = value
    end

    function self.getLeftSteering()
        return self._controller.inputs.right
    end

    function self.setRightSteering( value )
        self._controller.inputs.left = value
    end

    function self.getRightSteering()
        return self._controller.inputs.left
    end

    function self.enterFrame( event )

        self.setThrottle( self._keys[ "up" ] and 1 or 0 )
        self.setBrake( self._keys[ "down" ] and 1 or 0 )
        self.setHandbrake( self._keys[ "space" ] and 1 or 0 )
        self.setLeftSteering( self._keys[ "left" ] and 1 or 0 )
        self.setRightSteering( self._keys[ "right" ] and 1 or 0 )

        self._controller.update( 1 )

        self.x = self.x0 + self._controller.position.x
        self.y = self.y0 + self._controller.position.y

        self._wheels[ 1 ].rotation = math.deg( self._controller.steerAngle )
        self._wheels[ 2 ].rotation = math.deg( self._controller.steerAngle )

        self.rotation = deg( self._controller.heading )

    end

    function self.key( event )
        self._keys[ event.keyName ] = event.phase == "down"
    end

    Runtime:addEventListener( "enterFrame", self.enterFrame )
    Runtime:addEventListener( "key", self.key )

    -- Return the Car object
	return self

end

return Car
