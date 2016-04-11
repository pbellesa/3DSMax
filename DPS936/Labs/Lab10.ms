struct Turtle(
	position =[0,0,0],
	heading = 0,
	fn turnRight angle=(
		heading=heading-angle
	),
	fn turnLeft angle=(
		heading=heading+angle
	),
	fn moveForward numUnits = (
		newPosition=[cos heading,0,sin heading]
		newPosition=numUnits * newPosition
		position=position + newPosition
	)
)

fn draw codeString=(
	t=Turtle()
	for i = 1 to codeString.count do(
		case of (
			(codeString[i]=="A" or codeString[i]=="B"):
				(	c=cone radius1:1 height:10
					rotate c (angleaxis -(t.heading-90) [0,1,0])
					move c t.position
					t.moveForward(10)
				)
			(codeString[i]=="+"):
				t.turnLeft(60)
			(codeString[i]=="-"):
				t.turnRight(60)
			
		)
	)
)

fn substituteCodeString codeString=(
	newCodeString = ""
	for i = 1 to codeString.count do(
		case of (
			(codeString[i]=="A"): 
				append newCodeString "B-A-B"
			(codeString[i]=="B"):
				append newCodeString "A+B+A"
			(codeString[i]=="-"):
				append newCodeString "-"
			(codeString[i]=="+"):
				append newCodeString "+"
		)
	)
	newCodeString 
	return newCodeString
)

fn generate codeString numGenerations= (
	newCodeString = codeString
	for i = 1 to numGenerations do (
		newCodeString = substituteCodeString newCodeString
	)
	return newCodeString
)

fn myMain = (
	codeString = "A+B+A"
	
	codeString = generate codeString 8
	print codeString
	draw codeString
	
)	
myMain()