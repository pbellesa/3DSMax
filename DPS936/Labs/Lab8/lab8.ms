--Question 1: does integer division behave the same as it does in C/C++?
--Yes.

--Question 2: do variables have an explicit non-changing type?
-- No since it has automatic type conversion between int and double/float for math operations.

--Question 3: What do you see in your macro recorder when you do this?
--actionMan.executeAction 0 "40072"  -- Snaps: Snaps Toggle
--Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:30 radius1:10 radius2:0 mapcoords:on pos:[0,0,0] isSelected:on
fn generateGrass length width numBlades maxBendAngle minHeight maxHeight centre:[0,0,0]= (
	for i = 1 to numBlades do (
		
		_height = random minHeight maxHeight
		_bendAngle = random (maxBendAngle*-1) maxBendAngle

		_x = random (length/2*-1) ( length/2)
		_y = random  (width/2*-1) (width/2)
		_z = 0
		local p  = centre + [_x,_y,_z]

		blade = Cone smooth:on heightsegs:4 capsegs:1 sides:5 height:_height radius1:1 radius2:0 mapcoords:on pos:p
		addModifier blade (Bend())
		blade.bend.angle = _bendAngle
	)
)

generateGrass 50 50 200 30 5 20