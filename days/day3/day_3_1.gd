extends Node2D

var exampleMode = true

var tool_islands : Array[tool_island] = []
var letter_sprites : Array[AlfLetterSprite]
var number_regex : RegEx 
const ALFLETTER_SPRITE = preload("res://utility/Alfletter_sprite.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	number_regex = RegEx.new()
	number_regex.compile("\\d")
	var txtFile = FileAccess.open("res://days/day3/example.txt" if exampleMode else "res://days/day3/puzzle-input.txt", FileAccess.READ)
	var exampleText = txtFile.get_as_text() # Store text into string record
	var lines = exampleText.split("\n")
	#var x = 0
	#var y = 0
	var width = 10 if exampleMode else 140
	var height = 10 if exampleMode else 140
	for y in range(height):
		letter_sprites.append([])
		for x in range(width):
			if lines[y][x] == '.':
				print("dot")
				var ls = ALFLETTER_SPRITE.instantiate().get_node("LetterSprite")
				ls._show('.')
				ls.position += Vector2(x * 130, y * 130)
				add_child(ls.get_parent())
				#letter_sprites[y].append(ls)
			elif _d(lines[y][x]):
				print("number")
				var ls = ALFLETTER_SPRITE.instantiate().get_node("LetterSprite")
				ls._show(str(lines[y][x]))
				ls.position += Vector2(x * 130, y * 130)
				add_child(ls.get_parent())
				#letter_sprites[y].append(ls)				
			else:
				print("symbol found! TOOL ISLAND TIME")
				#⠄⠄⠄⠄⠄⠄⣀⣀⣀⣤⣶⣿⣿⣶⣶⣶⣤⣄⣠⣴⣶⣿⣿⣿⣿⣶⣦⣄⠄⠄
				#⠄⠄⣠⣴⣾⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦
				#⢠⠾⣋⣭⣄⡀⠄⠄⠈⠙⠻⣿⣿⡿⠛⠋⠉⠉⠉⠙⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿
				#⡎⣾⡟⢻⣿⣷⠄⠄⠄⠄⠄⡼⣡⣾⣿⣿⣦⠄⠄⠄⠄⠄⠈⠛⢿⣿⣿⣿⣿⣿
				#⡇⢿⣷⣾⣿⠟⠄⠄⠄⠄⢰⠁⣿⣇⣸⣿⣿⠄⠄⠄⠄⠄⠄⠄⣠⣼⣿⣿⣿⣿
				#⢸⣦⣭⣭⣄⣤⣤⣤⣴⣶⣿⣧⡘⠻⠛⠛⠁⠄⠄⠄⠄⣀⣴⣿⣿⣿⣿⣿⣿⣿
				#⠄⢉⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣦⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
				#⢰⡿⠛⠛⠛⠛⠻⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
				#⠸⡇⠄⠄⢀⣀⣀⠄⠄⠄⠄⠄⠉⠉⠛⠛⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
				#⠄⠈⣆⠄⠄⢿⣿⣿⣿⣷⣶⣶⣤⣤⣀⣀⡀⠄⠄⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿
				#⠄⠄⣿⡀⠄⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠂⠄⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿
				#⠄⠄⣿⡇⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠄⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿
				#⠄⠄⣿⡇⠄⠠⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠄⠄⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
				#⠄⠄⣿⠁⠄⠐⠛⠛⠛⠛⠉⠉⠉⠉⠄⠄⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿
				#⠄⠄⠻⣦⣀⣀⣀⣀⣀⣀⣤⣤⣤⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠄
				var island = tool_island.new()
				tool_islands.append(island)
				island.pos_of_tool = Vector2(x, y)
				
				#todo - special case
				var ls = ALFLETTER_SPRITE.instantiate().get_node("LetterSprite")
				ls._show("T")
				ls.position += Vector2(x * 130, y * 130)
				add_child(ls.get_parent())
				#letter_sprites[y].append(ls)				
				
				# Used to test the characters once we find symbole
				#var tl : String
				#var t : String
				#var tr : String
				#var ml : String
				#var mr : String
				#var bl : String
				#var b : String
				#var br : String
				#
				## Start in the top left and look clockwise around the symbol looking for numbers
				#if y-1 > 0 and x-1 > 0 and _d(lines[y-1][x-1]): #top left
					#print("Tool part spotted!")
					#var part = tool_part.new()
					#island.tool_parts.append(part)
					#if x-1 > 0 and _d(lines[y-1][x-4]):
						#a = lines[y-1][x-4]
					#if x-3 > 0 and _d(lines[y-1][x-4]):
						#a = lines[y-1][x-4]
					#if x-2 > 0 and _d(lines[y-1][x-4]):
						#a = lines[y-1][x-4]
					
				

# Wanted a shorthand for "Is this thing a digit?"
func _d(character: String):
	return number_regex.search(character) != null
	
	#for line in lines:			
		#if line.length() > 0:
			#var newGame : game_resource = GameRes.new()
			#all_games.append(newGame)
			##Example: 4:1green,3red,6blue;3green,6red;3green,15blue,14 red
			#newGame.id = line.split(":")[0].to_int()
			#var roundTexts = line.split(":")[1].split(";")
			#for roundText in roundTexts:
				#var newRound : round_resource = RoundRes.new()
				#newGame.rounds.append(newRound)
				##Example: 1green,3red,6blue
				#var roundSegments = roundText.split(",")
				#for segment in roundSegments:
					##Example: 1green
					#if segment.ends_with("blue"):
						#newRound.blue = segment.replace("blue", "").to_int()
					#if segment.ends_with("green"):
						#newRound.green = segment.replace("green", "").to_int()
					#if segment.ends_with("red"):
						#newRound.red = segment.replace("red", "").to_int()
	#
	#for game_r in all_games:
		#game_r.print_data()
	#
	#_setupNextGame()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
