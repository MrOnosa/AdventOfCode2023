extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var txtFile = FileAccess.open("res://days/day1/example.txt", FileAccess.READ)
	var exampleText = txtFile.get_as_text() # Store text into string record
	
	# Load the scene from a file
	var letter_sprite_scene = load("res://days/day1/letter_sprite.tscn")
	
	var pos = Vector2(70,70)
	for letter in exampleText:
		if letter == '\n':
			pos += Vector2(-pos.x + 70, 170)			
			continue
		var l : LetterSprite = letter_sprite_scene.instantiate()
		l.position = Vector2(pos)
		add_child(l)
		l._show(letter)
		pos += Vector2(110, 0)
		
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
