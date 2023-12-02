extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_day_1_1_button_pressed():
	get_tree().change_scene_to_file("res://days/day1/day1-1.tscn")
