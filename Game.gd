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
var redCubes : Array
var greenCubes : Array
var blueCubes : Array

signal failed
signal succeeded

# Called when the node enters the scene tree for the first time.
func _ready():
	if game_res.rounds.size() == 0:
		return
	
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
	if currentRound.red > 12:
		possible = false
	
	if not possible:
		environment.material = RED
		await get_tree().create_timer(1).timeout
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
		
		await get_tree().create_timer(1).timeout
		failed.emit()
		
	else:
		environment.material = GREEN
		await get_tree().create_timer(1).timeout
		environment.collision_layer = environment.collision_layer & (1 << 2)
		await get_tree().create_timer(.3).timeout
		environment.collision_layer = environment.collision_layer | (1 << 2)
	
