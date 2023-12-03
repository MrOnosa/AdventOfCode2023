extends Node3D

@export var game_res : game_resource
@onready var cube_spawn = $CubeSpawn
@onready var environment = $Environment
@onready var start_round_evaluation = $StartRoundEvaluation

const CUBE = preload("res://days/day2/cube.tscn")
const BLUE = preload("res://days/day2/blue.tres")
const GREEN = preload("res://days/day2/green.tres")
const RED = preload("res://days/day2/red.tres")
const DEFAULT_ENV = preload("res://days/day2/default_env.tres")

var currentRound : round_resource
var roundIndex = 0
var redCubes : Array
var greenCubes : Array
var blueCubes : Array
var timemod = 1

signal failed
signal succeeded

# Called when the node enters the scene tree for the first time.
func _ready():
	if game_res.rounds.size() == 0:
		return
	
	#start_round_evaluation.wait_time = start_round_evaluation.wait_time * timemod
	
	currentRound = game_res.rounds[0]
	setup_round()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup_round():
	environment.material = DEFAULT_ENV
	redCubes = []
	greenCubes = []
	blueCubes = []
	
	for i in range(currentRound.red):
		# Get random coordinates within the CubeSpawn box
		var random_position = Vector3(
		randf_range(-cube_spawn.scale.x / 2, cube_spawn.scale.x / 2),
		randf_range(-cube_spawn.scale.y / 2, cube_spawn.scale.y / 2),
		randf_range(-cube_spawn.scale.z / 2, cube_spawn.scale.z / 2)
		)
		
		var newCube = CUBE.instantiate()
		redCubes.append(newCube)
		add_child(newCube)
		
		#newCube.transform.origin = cube_spawn.transform.origin + Vector3(0, 0, 0)
		newCube.transform.origin = cube_spawn.to_global(random_position)
		newCube.get_node("CollisionShape3D/CSGBox3D").material = RED
		#newCube.get_node("CollisionShape3D").scale += Vector3(i/10.0,i/10.0,i/10.0)
		#newCube.angular_velocity = Vector3(randf_range(1,3),randf_range(1,3),randf_range(1,3))
	
	for i in range(currentRound.green):
		var random_position = Vector3(
			randf_range(-cube_spawn.scale.x / 2, cube_spawn.scale.x / 2),
			randf_range(-cube_spawn.scale.y / 2, cube_spawn.scale.y / 2),
			randf_range(-cube_spawn.scale.z / 2, cube_spawn.scale.z / 2)
		)
		
		var newCube = CUBE.instantiate()
		greenCubes.append(newCube)
		add_child(newCube)
		
		newCube.transform.origin = cube_spawn.to_global(random_position)
		newCube.get_node("CollisionShape3D/CSGBox3D").material = GREEN
		
	for i in range(currentRound.blue):
		var random_position = Vector3(
		randf_range(-cube_spawn.scale.x / 2, cube_spawn.scale.x / 2),
		randf_range(-cube_spawn.scale.y / 2, cube_spawn.scale.y / 2),
		randf_range(-cube_spawn.scale.z / 2, cube_spawn.scale.z / 2)
		)
		
		var newCube = CUBE.instantiate()
		blueCubes.append(newCube)
		add_child(newCube)
		
		newCube.transform.origin = cube_spawn.to_global(random_position)
		newCube.get_node("CollisionShape3D/CSGBox3D").material = BLUE
	

func _on_start_round_evaluation_timeout():
	start_round_evaluation.paused = true
	var possible = true
	if currentRound.red > 12 or currentRound.green > 13 or currentRound.blue > 14:
		possible = false
	
	if not possible:
		environment.material = RED
		await get_tree().create_timer(1 * timemod).timeout
		if currentRound.red > 12:
			for c in redCubes:
				c.angular_velocity = Vector3(randf_range(1,3),randf_range(1,3),randf_range(1,3))
				c.linear_velocity = Vector3(( -30 if c.transform.origin.x < 0 else 30 ),randf_range(-2,2),randf_range(-2,2))
		if currentRound.green > 13:
			for c in greenCubes:
				c.angular_velocity = Vector3(randf_range(1,3),randf_range(1,3),randf_range(1,3))
				c.linear_velocity = Vector3(( -30 if c.transform.origin.x < 0 else 30 ),randf_range(-2,2),randf_range(-2,2))
		if currentRound.blue > 14:
			for c in blueCubes:
				c.angular_velocity = Vector3(randf_range(1,3),randf_range(1,3),randf_range(1,3))
				c.linear_velocity = Vector3(( -30 if c.transform.origin.x < 0 else 30 ),randf_range(-2,2),randf_range(-2,2))
		
		await get_tree().create_timer(1 * timemod).timeout
		failed.emit()
		
	else:
		environment.material = GREEN
		await get_tree().create_timer(1 * timemod).timeout
		environment.use_collision = false
		for c in redCubes:
			c.linear_velocity = Vector3(0, 1, 0)
		for c in greenCubes:
			c.linear_velocity = Vector3(0, 1, 0)
		for c in blueCubes:
			c.linear_velocity = Vector3(0, 1, 0)
		await get_tree().create_timer(1 * timemod).timeout
		for c in redCubes:
			c.queue_free()
		for c in greenCubes:
			c.queue_free()
		for c in blueCubes:
			c.queue_free()
		environment.use_collision = true
		roundIndex += 1
		if roundIndex < game_res.rounds.size():
			currentRound = game_res.rounds[roundIndex]
			setup_round()
			start_round_evaluation.paused = false
		else:
			succeeded.emit()
