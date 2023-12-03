extends Node3D

@export var all_games : Array[game_resource] = []
const GameRes = preload("res://days/day2/game_res.gd")
const RoundRes = preload("res://days/day2/round_res.gd")
const GAME = preload("res://days/day2/game2.tscn")
@onready var score_lbl = $ScoreLbl
@onready var round_lbl = $RoundLbl



var currentGame 
var currentGameIndex = 0
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var txtFile = FileAccess.open("res://days/day2/puzzle-input.txt", FileAccess.READ)
	var exampleText = txtFile.get_as_text() # Store text into string record
	var lines = exampleText.split("\n")
	for line in lines:			
		#Remove clutter
		line = line.to_lower().replace("game", "").replace(" ", "")
		if line.length() > 0:
			var newGame : game_resource = GameRes.new()
			all_games.append(newGame)
			#Example: 4:1green,3red,6blue;3green,6red;3green,15blue,14 red
			newGame.id = line.split(":")[0].to_int()
			var roundTexts = line.split(":")[1].split(";")
			for roundText in roundTexts:
				var newRound : round_resource = RoundRes.new()
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
	
	for game_r in all_games:
		game_r.print_data()
	
	_setupNextGame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if Input.is_action_pressed("back"):
		# Change the scene
		get_tree().change_scene_to_file("res://menu.tscn")
	
func _on_completed(power):
	score += power
	currentGameIndex += 1
	_setupNextGame()
	
func _setupNextGame():	
	if currentGame != null:
		currentGame.queue_free()
		
	score_lbl.text = "Score: " + str(score)
	
	if currentGameIndex >= all_games.size():
		round_lbl.text = "Game is over after " + str(currentGameIndex) + " rounds."
	else:			
		round_lbl.text = "Round: " + str(all_games[currentGameIndex].id)
		currentGame = GAME.instantiate()
		currentGame.game_res = all_games[currentGameIndex]
		add_child(currentGame)
		currentGame.completed.connect(_on_completed)
	
