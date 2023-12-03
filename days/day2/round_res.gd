extends Resource

class_name round_resource

# Your data properties go here
@export var red : int
@export var green : int
@export var blue : int

# You can add methods to manipulate the data if needed
func print_data():
	print("red:", red)
	print("green:", green)
	print("blue:", blue)
