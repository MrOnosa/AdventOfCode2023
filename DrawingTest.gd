#@tool
extends Node2D

const POLYGON_RES = preload("res://days/day3/polygon_res.tres")
const ALFABETO = preload("res://textures/Alfabeto.png")
var rotation_angle = 50
var angle_from = 75
var angle_to = 195
var aligned = true
var colors : PackedColorArray
var timer = 0.05
var mouse_pos : Vector2
var rotation_angle_degrees = 230.0

# Called when the node enters the scene tree for the first time.
func _ready():
	colors = PackedColorArray()
	colors.append(Color.RED)
	colors.append(Color.BEIGE)
	colors.append(Color.YELLOW)
	colors.append(Color.BLANCHED_ALMOND)
	colors.append(Color.GREEN)
	colors.append(Color.GHOST_WHITE)
	colors.append(Color.RED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouse_pos = get_global_mouse_position()
	angle_from = angle_from if angle_from else 0
	angle_to = angle_to if angle_to else 360
	angle_from += rotation_angle * delta if rotation_angle else 1
	angle_to += rotation_angle * delta if rotation_angle else 1

	# We only wrap angles when both of them are bigger than 360.
	if angle_from > 360 and angle_to > 360:
		angle_from = wrapf(angle_from, 0, 360)
		angle_to = wrapf(angle_to, 0, 360)
		aligned = not aligned
	
	rotation_angle_degrees += delta * 20
	if rotation_angle_degrees > 360:
		rotation_angle_degrees = wrapf(rotation_angle_degrees, 0, 360)
		
	timer -= delta
	if colors and timer < 0:
		timer = 0.05
		var old = colors[0]
		colors.remove_at(0)
		colors.append(old)
	
	queue_redraw()
	
func _draw():
	var points = PackedVector2Array()
	points.append(Vector2(100, 100))
	points.append(Vector2(120, 100))
	points.append(Vector2(120, 200))
	points.append(Vector2(140, 240))
	points.append(Vector2(220, 200))
	points.append(Vector2(120, 150))
	points.append(Vector2(100, 100))
	draw_polyline_colors(points, colors, 3, true)
	# If using this method in a script that redraws constantly, move the
	# `default_font` declaration to a member variable assigned in `_ready()`
	# so the Control is only created once.
	var default_font = ThemeDB.fallback_font
	var default_font_size = ThemeDB.fallback_font_size
	draw_string_outline (default_font, Vector2(64, 64), "Hello world", HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)
	
	draw_texture (ALFABETO, mouse_pos if mouse_pos else Vector2(400,400) )
	draw_texture_rect  (ALFABETO, Rect2(500,0, 20, 400) , true)
	draw_texture_rect_region   (ALFABETO, Rect2(700,0, 20, 400), Rect2(10, 10, 70, 70) )
	var center = Vector2(200, 200)
	var radius = 80
	var angle_from = angle_from
	var angle_to = angle_to
	var color = Color(1.0, 0.0, 0.0)
	draw_circle_arc(center, radius, angle_from, angle_to, color)
	angle_from = 0
	angle_to = rotation_angle_degrees
	color = Color(0.0, 1.0, 0.0)
	center = Vector2(200,300)
	draw_circle_arc_poly(center, radius, angle_from, angle_to, color)
	#
	#draw_dashed_line(Vector2(300,300), Vector2(500,400), Color.BLUE, 2, 8, aligned if aligned else true)
	var ppoints = POLYGON_RES.Polygon
	var rotatoed_polygon = rotate_polygon(ppoints, rotation_angle_degrees)
	var scaled_polygon = scale_polygon(rotatoed_polygon, 0.1)
	var tranformed_polygon = transform_polygon(scaled_polygon, Vector2(300,300))
	draw_colored_polygon(tranformed_polygon, Color.GREEN_YELLOW)
	var tranformed_polygon2 = transform_polygon(rotate_polygon(transform_polygon(tranformed_polygon,  Vector2(-360,-240)), rotation_angle_degrees * 2), Vector2(300,300))
	draw_colored_polygon(tranformed_polygon2, Color.GREEN_YELLOW)
	var leftGearPoint = find_closest_point(tranformed_polygon, tranformed_polygon2)
	var rightGearPoint = find_closest_point(tranformed_polygon2, tranformed_polygon)
	draw_line(leftGearPoint, rightGearPoint, Color.ORCHID, 2, true)

func find_closest_point(set_a: Array, set_b: Array) -> Vector2:
	var closest_point_a = set_a[0]
	var min_distance = set_a[0].distance_squared_to(set_b[0])

	for point_a in set_a:
		for point_b in set_b:
			var distance = point_a.distance_squared_to(point_b)
			if distance < min_distance:
				min_distance = distance
				closest_point_a = point_a

	return closest_point_a

func transform_polygon(original_polygon: Array, transformation: Vector2) -> Array:
	var tranformed_polygon = []
	for p in original_polygon:
		var sp = p + transformation
		tranformed_polygon.append(sp)
	return tranformed_polygon

func scale_polygon(original_polygon: Array, scale: float) -> Array:
	var scaled_polygon = []
	for p in original_polygon:
		var sp = p * 0.1
		scaled_polygon.append(sp)
	return scaled_polygon

func rotate_polygon(original_polygon: Array, rotation_angle_degrees: float) -> Array:
	var rotated_polygon = []

	# Convert the rotation angle to radians
	var rotation_angle_radians = deg_to_rad(rotation_angle_degrees)

	for vertex in original_polygon:
		# Rotate each vertex by the specified angle
		var rotated_vertex = vertex.rotated(rotation_angle_radians)
		rotated_polygon.append(rotated_vertex)

	return rotated_polygon

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
		
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
