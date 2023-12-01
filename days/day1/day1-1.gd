extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var txtFile = FileAccess.open("res://days/day1/example.txt", FileAccess.READ)
	var exampleText = txtFile.get_as_text() # Store text into string record
	
	# Load the scene from a file
	var letter_sprite_scene = load("res://days/day1/letter_sprite.tscn")
	var line_sprite_scene = load("res://days/day1/line.tscn")
	
	var currentLine : Line = line_sprite_scene.instantiate()
	add_child(currentLine)
	var pos = Vector2(2,13)
	var lines = exampleText.split("\n")
	for line in lines:			
		currentLine = line_sprite_scene.instantiate()
		currentLine.line = line
		currentLine.position = pos
		add_child(currentLine)
		pos += Vector2(0, 170)		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
