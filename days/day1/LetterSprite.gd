class_name LetterSprite
extends Sprite2D

var move_amount = 7.0    # Amount to add to the x-coordinate
var wrap_around_limit = 246.0  # Wrap around when x-coordinate exceeds this value

func _ready():
	_show("a")

func _input(event):
	if(event.is_action_pressed("ui_left")):
		region_rect.position -= Vector2(move_amount, 0)
	
		if(region_rect.position.x < 0):
			_show('0')		
			
	if(event.is_action_pressed("ui_right")):
		region_rect.position += Vector2(move_amount, 0)
	
		if(region_rect.position.x > wrap_around_limit):
			region_rect.position = Vector2(0, region_rect.position.y)		
	
	if event is InputEventKey and event.pressed:
		var pressed_key = char(event.unicode)

		# Check if the pressed key corresponds to a letter
		if ('A' <= pressed_key and pressed_key <= 'Z') or ('a' <= pressed_key and pressed_key <= 'z') or ('0' <= pressed_key and pressed_key <= '9'):
			_show(pressed_key)
		
func _ord(character: String):
	return character.to_ascii_buffer()[0]
	
func _show(character: String):
	var position: int
	if  character >= 'a' and character <= 'z':
		position = _ord(character) - _ord('a')
	
	if character >= '0' and character <= '9':
		position = (_ord(character) - _ord('0')) + (26)
	
	region_rect.position = Vector2(move_amount * position, region_rect.position.y)		
