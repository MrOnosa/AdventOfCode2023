extends Node3D

@export var game_res : game_resource
@onready var red_cube_spawn = $RedCubeSpawn
@onready var green_cube_spawn = $GreenCubeSpawn
@onready var blue_cube_spawn = $BlueCubeSpawn

const CUBE = preload("res://days/day2/cube.tscn")
const BLUE = preload("res://days/day2/blue.tres")
const GREEN = preload("res://days/day2/green.tres")
const RED = preload("res://days/day2/red.tres")
const DEFAULT_ENV = preload("res://days/day2/default_env.tres")
@onready var red_environment = $RedEnvironment
@onready var green_environment = $GreenEnvironment
@onready var blue_environment = $BlueEnvironment
@onready var red_environment_2 = $RedEnvironment2
@onready var green_environment_2 = $GreenEnvironment2
@onready var blue_environment_2 = $BlueEnvironment2

var currentRound : round_resource
var roundIndex = 0
var redCubes : Array
var bestRedCubes : Array = []
var mostReds = 0
var greenCubes : Array
var bestGreenCubes : Array = []
var mostGreens = 0
var blueCubes : Array
var bestBlueCubes : Array = []
var mostBlues = 0
var timemod = 1

signal completed

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
	redCubes = []
	greenCubes = []
	blueCubes = []
	
	for i in range(currentRound.red):
		# Get random coordinates within the CubeSpawn box
		var random_position = Vector3(
		randf_range(-red_cube_spawn.scale.x / 2, red_cube_spawn.scale.x / 2),
		randf_range(-red_cube_spawn.scale.y / 2, red_cube_spawn.scale.y / 2),
		randf_range(-red_cube_spawn.scale.z / 2, red_cube_spawn.scale.z / 2)
		)
		
		var newCube = CUBE.instantiate()
		redCubes.append(newCube)
		add_child(newCube)
		
		newCube.transform.origin = red_cube_spawn.to_global(random_position)
		newCube.get_node("CollisionShape3D/CSGBox3D").material = RED
	
	for i in range(currentRound.green):
		# Get random coordinates within the CubeSpawn box
		var random_position = Vector3(
		randf_range(-green_cube_spawn.scale.x / 2, green_cube_spawn.scale.x / 2),
		randf_range(-green_cube_spawn.scale.y / 2, green_cube_spawn.scale.y / 2),
		randf_range(-green_cube_spawn.scale.z / 2, green_cube_spawn.scale.z / 2)
		)
		
		var newCube = CUBE.instantiate()
		greenCubes.append(newCube)
		add_child(newCube)
		
		newCube.transform.origin = green_cube_spawn.to_global(random_position)
		newCube.get_node("CollisionShape3D/CSGBox3D").material = GREEN
	
	for i in range(currentRound.blue):
		# Get random coordinates within the CubeSpawn box
		var random_position = Vector3(
		randf_range(-blue_cube_spawn.scale.x / 2, blue_cube_spawn.scale.x / 2),
		randf_range(-blue_cube_spawn.scale.y / 2, blue_cube_spawn.scale.y / 2),
		randf_range(-blue_cube_spawn.scale.z / 2, blue_cube_spawn.scale.z / 2)
		)
		
		var newCube = CUBE.instantiate()
		blueCubes.append(newCube)
		add_child(newCube)
		
		newCube.transform.origin = blue_cube_spawn.to_global(random_position)
		newCube.get_node("CollisionShape3D/CSGBox3D").material = BLUE
	
	
	await get_tree().create_timer(1 * timemod).timeout
			
	if redCubes.size() > bestRedCubes.size():
		await _handle_new_best(red_environment, redCubes, bestRedCubes)
		bestRedCubes = redCubes.duplicate(false)
	else:
		await _handle_keep_set(red_environment, redCubes)
		for c in redCubes:			
			c.queue_free()
			
	if greenCubes.size() > bestGreenCubes.size():
		await _handle_new_best(green_environment, greenCubes, bestGreenCubes)
		bestGreenCubes = greenCubes.duplicate(false)
	else:
		await _handle_keep_set(green_environment, greenCubes)
		for c in greenCubes:			
			c.queue_free()
			
	if blueCubes.size() > bestBlueCubes.size():
		await _handle_new_best(blue_environment, blueCubes, bestBlueCubes)
		bestBlueCubes = blueCubes.duplicate(false)
	else:
		await _handle_keep_set(blue_environment, blueCubes)
		for c in blueCubes:			
			c.queue_free()
		
	roundIndex += 1
	if roundIndex < game_res.rounds.size():
		currentRound = game_res.rounds[roundIndex]
		setup_round()
	else:
		red_environment_2.use_collision = false
		red_environment_2.material = GREEN		
		green_environment_2.use_collision = false
		green_environment_2.material = GREEN		
		blue_environment_2.use_collision = false
		blue_environment_2.material = GREEN		
		for c in bestRedCubes:			
			c.linear_velocity = Vector3(0, 1, 0)
		for c in bestGreenCubes:			
			c.linear_velocity = Vector3(0, 1, 0)
		for c in bestBlueCubes:			
			c.linear_velocity = Vector3(0, 1, 0)
		await get_tree().create_timer(1* timemod).timeout
		completed.emit(bestRedCubes.size() * bestGreenCubes.size() * bestBlueCubes.size())

func _handle_new_best(environment, cubes, bestCubes):	
	environment.material = GREEN
	environment.use_collision = false		
	for c in cubes:			
		c.linear_velocity = Vector3(0, 1, 0)		
	for c in bestCubes:			
		c.angular_velocity = Vector3(randf_range(1,3),randf_range(1,3),randf_range(1,3))
		c.linear_velocity = Vector3(randf_range(-2,2),randf_range(-2,2),( -30 if c.transform.origin.z < 0 else 30 ))
	await get_tree().create_timer(.4 * timemod).timeout
	environment.material = DEFAULT_ENV
	environment.use_collision = true
	await get_tree().create_timer(.3 * timemod).timeout
	for c in bestCubes:			
		c.queue_free()

func _handle_keep_set(environment, cubes):	
	environment.material = RED		
	for c in cubes:			
		c.angular_velocity = Vector3(randf_range(1,3),randf_range(1,3),randf_range(1,3))
		c.linear_velocity = Vector3(randf_range(-2,2),randf_range(-2,2),( -30 if c.transform.origin.z < 0 else 30 ))		
	await get_tree().create_timer(.4 * timemod).timeout
	environment.material = DEFAULT_ENV
	environment.use_collision = true
	await get_tree().create_timer(.3 * timemod).timeout
