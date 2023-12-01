class_name Line
extends Node2D

@export var line = "" : set = _setLine

var letters : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _setLine(l):
	line = l
	var x = 0.0
	# Load the scene from a file
	var letter_sprite_scene = load("res://days/day1/letter_sprite.tscn")
	for letter in line:
		if letter == '\n':
			continue
		var ls : LetterSprite = letter_sprite_scene.instantiate()
		ls.position += Vector2(x,0)
		add_child(ls)
		ls._show(letter)
		x += 130.0
		letters.append(ls)
