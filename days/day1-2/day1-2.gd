extends Node2D

var total = 0
var scoreLine: Line2
var lines_complete = 0
var lines_to_process = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#var txtFile = FileAccess.open("res://days/day1/example.txt", FileAccess.READ)
	var txtFile = FileAccess.open("res://days/day1-2/puzzle-input.txt", FileAccess.READ)
	var exampleText = txtFile.get_as_text() # Store text into string record
	
	# Load the scene from a file
	var letter_sprite_scene = load("res://days/day1-2/letter_sprite.tscn")
	var line_sprite_scene = load("res://days/day1-2/line2.tscn")
	
	scoreLine = line_sprite_scene.instantiate()
	scoreLine.process = false #This is just for instruction that's it thats all
	scoreLine.position = Vector2(20, 20)
	scoreLine.line = ""
	add_child(scoreLine)
	
	var instructionsLine : Line2 = line_sprite_scene.instantiate()
	instructionsLine.process = false #This is just for instruction that's it thats all
	instructionsLine.position = Vector2(20, 190)
	instructionsLine.line = "use mouse wheel and arrow keys"
	add_child(instructionsLine)
	
	var pos = Vector2(20, 420)
	var lines = exampleText.split("\n")
	for line in lines:			
		if line.length() > 0:
			lines_to_process += 1
			var currentLine = line_sprite_scene.instantiate()
			currentLine.line = line
			currentLine.position = pos
			add_child(currentLine)
			currentLine.letters_found.connect(_add_to_total)
			pos += Vector2(0, 170)		
	
	_add_to_total(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	pass
	
func _add_to_total(num):
	lines_complete += 1
	total += num
	if scoreLine != null:
		scoreLine.line = format_number_with_commas(total)
		if lines_to_process == lines_complete:
			# Done!
			scoreLine.get_node("InsaneoStyle").start()

func format_number_with_commas(number):
	var formatted_number = str(number)
	
	# Insert commas every three digits from the end
	var length = formatted_number.length()
	for i in range(length - 3, 0, -3):
		formatted_number = formatted_number.insert(i, ",")
	
	return formatted_number
