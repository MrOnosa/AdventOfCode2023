extends Node3D

@export var all_games : Array[game_resource] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var txtFile = FileAccess.open("res://days/day2/example.txt", FileAccess.READ)
	var exampleText = txtFile.get_as_text() # Store text into string record
	var lines = exampleText.split("\n")
	for line in lines:			
		#Remove clutter
		line = line.to_lower().replace("game", "").replace(" ", "")
		if line.length() > 0:
			var newGame : game_resource = ResourceLoader.load("res://days/day2/game_res.gd").new()
			all_games.append(newGame)
			#Example: 4:1green,3red,6blue;3green,6red;3green,15blue,14 red
			newGame.id = line.split(":")[0].to_int()
			var roundTexts = line.split(":")[1].split(";")
			for roundText in roundTexts:
				var newRound : round_resource = ResourceLoader.load("res://days/day2/round_res.gd").new()
				newGame.rounds.append(newRound)
				#Example: 1green,3red,6blue
				var roundSegments = roundText.split(",")
				for segment in roundSegments:
					#Example: 1green
					if segment.ends_with("blue"):
						newRound.blue = segment.replace("blue", "").to_int()
					if segment.ends_with("green"):
						newRound.green = segment.replace("green", "").to_int()
					if segment.ends_with("red"):
						newRound.red = segment.replace("red", "").to_int()
	
	for game in all_games:
		game.print_data()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
