extends Camera2D

var move_speed = 100.0
var zoom_speed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("ui_right"):
		position.x += move_speed * delta
	if Input.is_action_pressed("ui_left"):
		position.x -= move_speed * delta
	if Input.is_action_pressed("ui_up"):
		position.y -= move_speed * delta
	if Input.is_action_pressed("ui_down"):
		position.y += move_speed * delta

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Zoom out
			zoom /= (1.0 + zoom_speed)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= (1.0 + zoom_speed)
			
