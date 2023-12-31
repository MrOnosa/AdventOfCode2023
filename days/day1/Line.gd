class_name Line1
extends Node2D

@export var line = "" : set = _setLine
@export var timer : Timer
var process = true

signal letters_found

var letters : Array[LetterSprite] = []
var leftmost_letter_index : int = 0
var rightmost_letter_index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _setLine(l):
	for let in letters:
		let.queue_free()
	letters = []
	line = l	
	rightmost_letter_index = line.length() - 1
	var x = 0.0
	# Load the scene from a file
	var letter_sprite_scene = load("res://days/day1/letter_sprite.tscn")
	for letter in line:
		if letter == '\n':
			continue
		var ls : LetterSprite = letter_sprite_scene.instantiate().get_node("LetterSprite")
		ls.position += Vector2(x,0)
		add_child(ls.get_parent())
		ls._show(letter)
		x += (30.0 if letter == ',' else 130.0)
		letters.append(ls)
	#timer.wait_time = 1.0
	#timer.timeout.connect(_on_timer_timeout)
	if process:
		timer.autostart = true
	else:
		for i in range(0, rightmost_letter_index+1):
			letters[i]._focus()

func _on_timer_timeout():		
	if letters.size() == 0 or leftmost_letter_index < 0 or rightmost_letter_index >= letters.size():
		return
	
	if not letters[leftmost_letter_index].focusing and not letters[leftmost_letter_index].correct:
		letters[leftmost_letter_index]._focus()
	elif letters[leftmost_letter_index].focusing:
		if letters[leftmost_letter_index]._eval():
			letters[leftmost_letter_index]._correct()
		else:
			letters[leftmost_letter_index]._incorrect()
			leftmost_letter_index += 1
	
	if not letters[rightmost_letter_index].focusing and not letters[rightmost_letter_index].correct:
		letters[rightmost_letter_index]._focus()
	elif letters[rightmost_letter_index].focusing:
		if letters[rightmost_letter_index]._eval():
			letters[rightmost_letter_index]._correct()
		else:
			letters[rightmost_letter_index]._incorrect()
			rightmost_letter_index -= 1
	
	if letters[leftmost_letter_index].correct and letters[rightmost_letter_index].correct:		
		timer.stop()
		letters_found.emit(_get_total())
		for i in range(leftmost_letter_index+1, rightmost_letter_index):
			letters[i]._incorrect()

func _get_total():
	return ((_ord(letters[leftmost_letter_index].letter) - _ord('0')) * 10) + (_ord(letters[rightmost_letter_index].letter) - _ord('0'))

func _ord(character: String):
	return character.to_ascii_buffer()[0]

var insaneo_style_interation = 0
func _go_insaneo_style():
	insaneo_style_interation += 1
	for i in range(0, line.length()):
		var style = (i + insaneo_style_interation) % 4
		if style == 0:
			letters[i]._focus()
		elif style == 1:
			letters[i]._default()
		elif style == 2:
			letters[i]._correct()
		elif style == 3:
			letters[i]._bonus()
			
	
