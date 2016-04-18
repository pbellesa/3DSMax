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
		newPosition=[sin heading,cos heading,0]
		newPosition=numUnits * newPosition
		position=position + newPosition
	)
)
global track = railTrack()
global decorationPosition = [0,0,0]

fn generateSpline numVertices length angle basis: angleOffset:0 = (
	
	local ctn = splineShape()
	local spIdx = addNewSpline ctn
	local pos = [0,0,0]
	addKnot ctn spIdx #smooth #curve pos
	for i = 2 to numVertices do ( 
		pos.y += length / ((numVertices - 1) as float)
		addKnot ctn spIdx #smooth #curve pos
		
	)
	updateShape ctn
		
	addModifier ctn (Bend angle:angle axis:1)
	convertto ctn SplineShape
	
	if ( basis != undefined) then (
		local lastSpIdx = numSplines basis
		local lastKnotIdx = numKnots basis lastSpIdx
		local lastKnotPos = getKnotPoint basis lastSpIdx lastKnotIdx
		ctn.position = lastKnotPos
		decorationPosition = lastKnotPos

		rotate ctn (angleaxis -(angleOffset) [0,0,1])
		addAndWeld basis ctn 0.1
		updateShape basis
		global TESTCTN
		TESTCTN = ctn
		ctn = basis
	)
	
	return ctn
)
fn generateRail trackArray =(

	spline = undefined
	for i = 1 to trackArray.count do (
		case of (
			(trackArray[i]=="straight"):
			(
				spline = generateRailBase basis:spline angleOffset:track.heading position:i totalTracks:trackArray.count previousTrack:rail
				track.moveForward(155)
				transformPos = [-40,-40,-20]
				if track.heading < 0 then direction = 1
				else direction = -1
				case of (
					((abs track.heading  == 0)): 
						transformPos = [40,(80 * direction),-20]
					((abs track.heading  == 90)): 
						transformPos = [(-80 * direction),40,-20]
					((abs track.heading  == 180)): 
						transformPos = [-40,(-80 * direction),-20]
					((abs track.heading  == 270)): 
						transformPos = [(80 * direction),-40,-20]
				)
				
				generateDecorationStation position:(decorationPosition + transformPos) 
			)
			(trackArray[i]=="left"):
			(
				spline = generateRailCurved angleCurve:-45 basis:spline angleOffset:track.heading position:i totalTracks:trackArray.count previousTrack:rail	
				track.moveForward(155)
				generateDecorationLightPost position:(decorationPosition + [(sin track.heading *155),(cos track.heading*155),-20]) 
				track.turnLeft(45)
	
			)
			(trackArray[i]=="right"):
			(
				spline = generateRailCurved basis:spline angleOffset:track.heading position:i totalTracks:trackArray.count previousTrack:rail
				
				track.moveForward(155)
				generateDecorationWaterTower position:(decorationPosition + [(sin track.heading *155),(cos track.heading*155),-20]) 
				track.turnRight(45) 
				
			)
		)
		
	
	)
)
fn generateRailBase groupName:"railStraight" trackSegs:1 angleCurve:0 basis: angleOffset:0 totalTracks:1 position:1 =(
	
	trackLeft = box length:155 width:2 height:1.5 lengthsegs: trackSegs
	trackRight = box length:155 width:2 height:1.5 lengthsegs: trackSegs
	
	move trackLeft [-8,0,0]
	move trackRight [8,0,0]
	
	rail = convertToPoly(trackLeft)
	rail.attach trackRight rail
	
	for i = 1 to 15 do
	(
		plank = box length:5 width:30 height:1
		plank.wirecolor = (color 139 69 19)
		plank.pos = [0, (trackLeft.pos.y - (160/2)), 0]
		move plank [0,(10*i),-0.75]

		rail.attach plank rail
	)
	rail.wirecolor = (color 139 69 19)
	group rail prefix:groupName
	rotate rail (angleaxis -(angleOffset) [0,0,1])

	
	spline = generateSpline 14 155 angleCurve basis:basis angleOffset:angleOffset
	
	addModifier rail (spacePathDeform path:spline axis:1 rotation:-90 Percent_along_path:(100 * ((position-1.0)/(totalTracks) + (0.5/totalTracks)) )  )
 	rail.transform = spline.transform 
	move rail [-8.5,0,-20]
-- 	decorationPosition = spline.transform

	return spline 
)
fn generateRailCurved angleCurve:45 groupName:"railLeft" basis: angleOffset:0 position:1 totalTracks:1=(
	if angleCurve > 0 do groupName = "railRight"
	return generateRailBase trackSegs:15 groupName:groupName angleCurve:angleCurve basis:basis angleOffset:angleOffset position:position totalTracks:totalTracks
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
	group lightPost prefix:"lightPost" 
	
	move lightPost position
	
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
	group waterTower prefix:"waterTower" 
	move waterTower position

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
	
	
	stationPoly = convertToPoly(station[1])
	for i = 2 to station.count do stationPoly.attach station[i] stationPoly
	rotate stationPoly (angleaxis -(track.heading) [0,0,1])
	move stationPoly position
	max select none
	
)


fn main=(
	theTrack = #(
		    "right",
    "right",
    "straight",
    "left",
    "left",
    "right",
    "right",
    "straight",
    "left",
    "left",
    "left",
    "left",
    "straight",
    "straight",
    "straight",
    "left",
    "left",
    "straight",
    "straight",
    "straight"

)
	generateRail theTrack
	
)


main()