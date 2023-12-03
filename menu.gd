extends Control

@onready var rich_text_label = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_day_1_1_button_pressed():
	get_tree().change_scene_to_file("res://days/day1/day1-1.tscn")
	
func _on_day_1_2_button_pressed():
	get_tree().change_scene_to_file("res://days/day1-2/day1-2.tscn")

func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://days/day2/day2_1.tscn")


func _on_button_3_mouse_entered():
	var txtFile = FileAccess.open("res://days/day2/desc.txt", FileAccess.READ)
	var exampleText = txtFile.get_as_text() # Store text into string record
	rich_text_label.text = exampleText

func _on_button_mouse_entered():
	var txtFile = FileAccess.open("res://days/day1/desc.txt", FileAccess.READ)
	var exampleText = txtFile.get_as_text() # Store text into string record
	rich_text_label.text = exampleText


func _on_button_4_pressed():
	get_tree().change_scene_to_file("res://days/day2/day2_2.tscn")
