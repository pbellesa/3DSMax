fn generateRail groupName:"railStraight" trackSegs:1 angleCurve:0=(
	
	trackLeft = box length:155 width:2 height:1.5 lengthsegs: trackSegs
	trackRight = box length:155 width:2 height:1.5 lengthsegs: trackSegs
	
	trackLeft.wirecolor = (color 192 192 192)
	trackRight.wirecolor = (color 192 192 192)
	
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
	
	group rail prefix:groupName select:true

	
	if angleCurve != 0 do 
	(

 		addModifier rail (bend angle:angleCurve axis:1)
		rotate rail (angleaxis (-angleCurve/2) [0,0,1])

	)

)



fn generateRailCurved angleCurve:45 groupName:"railLeft"=(
	if angleCurve > 0 do groupName = "railRight"
	generateRail trackSegs:15 groupName:groupName angleCurve:angleCurve
)

generateRailCurved()
generateRail()
generateRailCurved angleCurve:-45