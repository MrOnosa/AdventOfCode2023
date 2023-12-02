extends Node2D

var total = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#var txtFile = FileAccess.open("res://days/day1/example.txt", FileAccess.READ)
	var txtFile = FileAccess.open("res://days/day1/puzzle-input.txt", FileAccess.READ)
	var exampleText = txtFile.get_as_text() # Store text into string record
	
	# Load the scene from a file
	var letter_sprite_scene = load("res://days/day1/letter_sprite.tscn")
	var line_sprite_scene = load("res://days/day1/line.tscn")
	
	var currentLine : Line = line_sprite_scene.instantiate()
	add_child(currentLine)
	var pos = Vector2(20, 20)
	var lines = exampleText.split("\n")
	for line in lines:			
		if line.length() > 0:
			currentLine = line_sprite_scene.instantiate()
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
	total += num
	$Camera2D/Label.text = format_number_with_commas(total)

func format_number_with_commas(number):
	var formatted_number = str(number)
	
	# Insert commas every three digits from the end
	var length = formatted_number.length()
	for i in range(length - 3, 0, -3):
		formatted_number = formatted_number.insert(i, ",")
	
	return formatted_number
