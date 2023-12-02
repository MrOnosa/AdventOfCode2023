extends Resource

class_name round_resource

# Your data properties go here
@export var blue : int = 0
@export var red : int = 0
@export var green : int = 0

# You can add methods to manipulate the data if needed
func print_data():
	print("blue:", blue)
	print("red:", red)
	print("green:", green)
