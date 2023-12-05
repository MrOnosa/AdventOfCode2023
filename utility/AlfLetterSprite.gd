class_name AlfLetterSprite
extends Sprite2D

var move_amount = 7.0    # Amount to add to the x-coordinate
var wrap_around_limit = 246.0  # Wrap around when x-coordinate exceeds this value
var default_y = 23
var focus_y = 15
var incorrect_y = 7
var correct_y = 31
var bonus_y = 39

@export var letter: String

func _ready():
	pass

#func _input(event):
	#if(event.is_action_pressed("ui_left")):
		#region_rect.position -= Vector2(move_amount, 0)
	#
		#if(region_rect.position.x < 0):
			#_show('0')		
			#
	#if(event.is_action_pressed("ui_right")):
		#region_rect.position += Vector2(move_amount, 0)
	#
		#if(region_rect.position.x > wrap_around_limit):
			#region_rect.position = Vector2(0, region_rect.position.y)		
	#
	#if event is InputEventKey and event.pressed:
		#var pressed_key = char(event.unicode)
#
		## Check if the pressed key corresponds to a letter
		#if ('A' <= pressed_key and pressed_key <= 'Z') or ('a' <= pressed_key and pressed_key <= 'z') or ('0' <= pressed_key and pressed_key <= '9'):
			#_show(pressed_key)
		
func _ord(character: String):
	return character.to_ascii_buffer()[0]
	
func _show(character: String):
	letter = character
	var position: int
			
	if  character >= 'a' and character <= 'z':
		position = _ord(character) - _ord('a')	
	elif character >= '0' and character <= '9':
		position = (_ord(character) - _ord('0')) + (26)
	else:
		position = -100
	
	region_rect.position = Vector2(move_amount * position, region_rect.position.y)		

func _default():
	region_rect.position = Vector2(region_rect.position.x, default_y)
	
func _focus():
	region_rect.position = Vector2(region_rect.position.x, focus_y)
	
func _bonus():
	region_rect.position = Vector2(region_rect.position.x, bonus_y)
	
func _incorrect():
	region_rect.position = Vector2(region_rect.position.x, incorrect_y)	
	
func _correct():
	region_rect.position = Vector2(region_rect.position.x, correct_y)

func _eval():
	return '0' <= letter and letter <= '9'
