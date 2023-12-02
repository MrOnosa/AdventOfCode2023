extends Resource

class_name game_resource

# Your data properties go here
@export var id : int
@export var rounds : Array[round_resource]
	
# You can add methods to manipulate the data if needed
func print_data():
	print("id:", id)
	print("rounds:", rounds.size())
	for r in rounds:
		print(r.print_data())
		print(" ")
