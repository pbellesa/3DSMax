--Question 1: does integer division behave the same as it does in C/C++?
--Yes.

--Question 2: do variables have an explicit non-changing type?
-- No since it has automatic type conversion between int and double/float for math operations.

--Question 3: What do you see in your macro recorder when you do this?
--actionMan.executeAction 0 "40072"  -- Snaps: Snaps Toggle
--Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:30 radius1:10 radius2:0 mapcoords:on pos:[0,0,0] isSelected:on

fn generateSnowball =(
	for i = 1 to 6 do (
		_height = 30
		_radius = 3
		main = Cone smooth:on heightsegs:4 capsegs:1 sides:5 height:_height radius1:_radius radius2:0 mapcoords:on pos:[0,0,0]
		for k = 1 to 6 do (
			small = Cone smooth:on heightsegs:4 capsegs:1 sides:5 height:(_height*0.3) radius1:(_radius*0.3)  radius2:0 mapcoords:on pos:[0,0,(_height*0.6)]
		)
	)
)

generateSnowball()