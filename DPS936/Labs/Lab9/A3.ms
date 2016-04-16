struct railTrack(
	position =[0,0,0],
	heading = 0,
	fn turnRight angle=(
		heading=heading+angle
	),
	fn turnLeft angle=(
		heading=heading-angle
	),
	fn moveForward numUnits = (
		newPosition=[cos heading,0,sin heading]
		newPosition=numUnits * newPosition
		position=position + newPosition
	)
)

fn generateSpline numVertices length angle basis: angleOffset:0 = (
	-- Create spline shape
	local ctn = splineShape()
	local spIdx = addNewSpline ctn
	local pos = [0,0,0]
	addKnot ctn spIdx #smooth #curve pos
	for i = 2 to numVertices do (
		pos.y += length / ((numVertices - 1) as float)
		addKnot ctn spIdx #smooth #curve pos
	)
	updateShape ctn
	
	-- Add bend modifier and collapse
	
	addModifier ctn (Bend angle:angle axis:1)
	convertto ctn SplineShape
	
	
	-- If basis provided, place at end of basis and weld
	
	if ( basis != undefined) then (
		local lastSpIdx = numSplines basis
		local lastKnotIdx = numKnots basis lastSpIdx
		local lastKnotPos = getKnotPoint basis lastSpIdx lastKnotIdx
		ctn.position = lastKnotPos
		
		-- Need to rotate new piece to total track rotation so far here...
		rotate ctn (angleaxis -(angleOffset+angle) [0,0,1])
		print ("ANGLE : "  + (angleOffset as string))
		addAndWeld basis ctn 0.1
		updateShape basis
		global TESTCTN
		TESTCTN = ctn
		ctn = basis
	)
	
-- 	move ctn [0, -(length/2), 0]
	
	return ctn
	
)
fn generateRail trackArray =(
	track = railTrack()
	spline = undefined
	for i = 1 to trackArray.count do (
		case of (
			(trackArray[i]=="straight"):
			(
				print ("STRAIGHT : "  + (track.heading as string))
				spline = generateRailBase basis:spline angleOffset:track.heading
				
			)
			(trackArray[i]=="left"):
			(
				print ("LEFT : "  + (track.heading as string))
				spline = generateRailCurved angleCurve:-45 basis:spline angleOffset:track.heading
				
				track.turnLeft(45) 
			)
			(trackArray[i]=="right"):
			(
				print ("RIGHT : "  + (track.heading as string))
				spline = generateRailCurved basis:spline angleOffset:track.heading
				
				track.turnRight(45) 
			)
		)
	)
)
fn generateRailBase groupName:"railStraight" trackSegs:1 angleCurve:0 basis: angleOffset:0 =(
	
-- 	trackLeft = box length:155 width:2 height:1.5 lengthsegs: trackSegs
-- 	trackRight = box length:155 width:2 height:1.5 lengthsegs: trackSegs
-- 	
-- 	trackLeft.wirecolor = (color 192 192 192)
-- 	trackRight.wirecolor = (color 192 192 192)
-- 	
-- 	move trackLeft [-8,0,0]
-- 	move trackRight [8,0,0]
-- 	
-- 	rail = convertToPoly(trackLeft)
-- 	rail.attach trackRight rail
-- 	
-- 	for i = 1 to 15 do
-- 	(
-- 		plank = box length:5 width:30 height:1
-- 		plank.wirecolor = (color 139 69 19)
-- 		plank.pos = [0, (trackLeft.pos.y - (160/2)), 0]
-- 		move plank [0,(10*i),-0.75]

-- 		rail.attach plank rail
-- 	)
-- 	
-- 	group rail prefix:groupName select:true

-- 	if angleCurve != 0 do 
-- 	(

--  		addModifier rail (bend angle:angleCurve axis:1)
-- 		rotate rail (quat (-angleCurve/2) [0,0,1])

-- 	)
	spline = generateSpline 14 155 angleCurve basis:basis angleOffset:angleOffset
-- 	rail.center =  spline.pos
-- 	if angleCurve > 0 do move rail [-20, 10,0]
-- 	if angleCurve < 0 do move rail [8, 0,0]
	return spline 
)
fn generateRailCurved angleCurve:45 groupName:"railLeft" basis: angleOffset:2 =(
	if angleCurve > 0 do groupName = "railRight"
	return generateRailBase trackSegs:15 groupName:groupName angleCurve:angleCurve basis:basis
)
fn generateDecoration decorationName:"lightPost" position:[0,0,0]=(
	case of 
	(
		(decorationName[i]=="lightPost"): 
		(
			generateDecorationLightPost position:position
		)
		(decorationName[i]=="waterTower"): 
		(
			generateDecorationWaterTower position:position
		)
		(decorationName[i]=="station"): 
		(
			generateDecorationStation position:position
		)
	)
)
fn generateDecorationLightPost position:[0,0,0]=(
	lightPost = #()
	append lightPost (cylinder radius:3 height:1 sides:8)
	append lightPost (cylinder radius:1 height:25 sides:8)
	append lightPost (cone radius1:2 radius2:4 height:5 sides:8 heightSegs:1) 	
	append lightPost (cylinder radius:5 height:1 sides:8)
	
	move lightPost[2] [0,0,1]
	move lightPost[3] [0,0,26]
	move lightPost[4] [0,0,31]
	group lightPost prefix:"lightPost" select:true
	in coordsys local $.pos = position
	max select none
)
fn generateDecorationWaterTower position:[0,0,0]=(
	waterTower = #()
	append waterTower (cylinder radius:1 height:40 sides:8)
	append waterTower (cylinder radius:1 height:40 sides:8)
	append waterTower (cylinder radius:1 height:40 sides:8)
	append waterTower (cylinder radius:1 height:40 sides:8)
	
	append waterTower (sphere radius:14 height:25 sides:8 segments:8 hemisphere:0.5)
	append waterTower (cylinder radius:16 height:2 sides:8)
	append waterTower (cone radius1:16 radius2:0 height:15 sides:8 heightSegs:1) 
	
	move waterTower[1] [10,10,0]
	move waterTower[2] [-10,10,0]
	move waterTower[3] [-10,-10,0]
	move waterTower[4] [10,-10,0]
	
	addModifier waterTower[5] (Mirror mirror_axis:2)
	move waterTower[5] [0,0,40]
	convertToMesh waterTower[5]
	extrudeFace waterTower[5]  #{26,28,30,32,34,36,38,40} 20 100 dir:[0,0,1]
	
	move waterTower[6] [0,0,40]
	move waterTower[7] [0,0,60]
	group waterTower prefix:"waterTower" select:true
	in coordsys local $.pos = position
	max select none
)
fn generateDecorationStation position:[0,0,0]=(
	station = #()
	append station (box length:50 width:20 height:1 )
	append station (box length:1 width:15 height:25 )
	append station (box length:1 width:15 height:25 )
	append station (pyramid depth:50 width:25 height:5 )
	
	move station[2] [0,-20,1]
	move station[3] [0,20,1]
	move station[4] [0,0,26]
	
	
	group station prefix:"station" select:true
	in coordsys local $.pos = position
	max select none
	
)


fn main=(
	theTrack = #("left","straight","right","straight")
	generateRail theTrack
)


main()