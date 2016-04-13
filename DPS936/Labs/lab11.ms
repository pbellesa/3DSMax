--Question 1: does integer division behave the same as it does in C/C++?
--Yes.

--Question 2: do variables have an explicit non-changing type?
-- No since it has automatic type conversion between int and double/float for math operations.

--Question 3: What do you see in your macro recorder when you do this?
--actionMan.executeAction 0 "40072"  -- Snaps: Snaps Toggle
--Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:30 radius1:10 radius2:0 mapcoords:on pos:[0,0,0] isSelected:on

-- utility settings "Settings"
-- (
-- 	spinner grass_length "Grass Length" range:[0,100,10] 
-- 	spinner grass_width "Grass Length" range:[0,100,10] 
-- 	
-- )
global objList
if objList == undefined then objList = #()

fn generateGrass length width numBlades maxBendAngle minHeight maxHeight centre:[0,0,0]= (
	for i = 1 to numBlades do (
		
		_height = random minHeight maxHeight
		_bendAngle = random (maxBendAngle*-1) maxBendAngle

		_x = random (length/2*-1) ( length/2)
		_y = random  (width/2*-1) (width/2)
		_z = 0
		local p  = centre + [_x,_y,_z]

		blade = Cone smooth:on heightsegs:4 capsegs:1 sides:5 height:_height radius1:1 radius2:0 mapcoords:on pos:p
		append objList blade
		addModifier blade (Bend())
		blade.bend.angle = _bendAngle
	)
)

try (
	DestroyDialog settings
) catch()



struct FieldParams (
	width, length,
	heightMin, heightMax,
	angleMin, angleMax, centre, numBlades
)

fn CreateField params = (
	generateGrass params.length params.width params.numBlades params.angleMax params.heightMin params.heightMax
	
	
)

fn ClearField = (
	for item in objList do delete item
	objList.count = 0
)

rollout settings "Lab 11" (
	label lblTitle "Settings" align:#center
	group "Field Dimensions" (
		spinner spnWidth "Width" range:[0,1000,200] align:#left across:2
		spinner spnLength "Length" range:[0,1000,200] align:#left
	)
	group "Height" (
		slider spnMinHeight "Min" range:[0, 500, 10] align:#left across:2
		slider spnMaxHeight "Max" range:[0, 500, 250] align:#left
	)
	group "Position" (
		edittext  boxPosX "x" range:[0,100, 0] align:#left type:#integer across:3 fieldWidth:30 text:"0" labelOnTop: true
		edittext  boxPosY "y" range:[0,100, 0] align:#left type:#integer across:2 fieldWidth:30 text:"0" labelOnTop: true
		edittext  boxPosZ "z" range:[0,100, 0] align:#left type:#integer across:1 fieldWidth:30 text:"0" labelOnTop: true
		
	)
	group "Angle" (
		angle angMin "Min" align:#center across:2
		angle angMax "Max" align:#center
	)
	group "# of Blades" (
		slider spnNumOfBlades "Max" range:[0, 500, 250] align:#left
	)

	button btnDo "Create" align:#center across:2
	button btnClear "Clear" align:#center

	on btnDo pressed do CreateField (FieldParams \
		width:spnWidth.value \
		length:spnLength.value \
		heightMin:spnMinHeight.value \
		heightMax:spnMaxHeight.value \
		centre:[(boxPosX.text as integer), (boxPosY.text as integer), (boxPosZ.text as integer)] \
		angleMin:angMin.degrees \
		angleMax:angMax.degrees\
		numBlades: spnNumOfBlades.value)
	on btnClear pressed do ClearField()
)

CreateDialog settings 300 450
