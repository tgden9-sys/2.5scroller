extends Node3D

const LEVEL_END := 118.0
const PLAYER_SCENE := preload("res://game/player/player.tscn")
const CAMERA_SCRIPT := preload("res://game/camera/player_camera.gd")

var player: PlayerController
var objective_label: Label
var progress_label: Label
var message_label: Label
var _checkpoint := 0
var _wisps := 0
var _complete := false
var _time := 0.0
var _water_material: StandardMaterial3D
var _wisp_nodes: Array[Node3D] = []

var moss := _material(Color("#4d7044"), 0.95)
var moss_light := _material(Color("#78945a"), 0.9)
var bark := _material(Color("#4b2f22"), 1.0)
var bark_light := _material(Color("#72503a"), 0.95)
var stone := _material(Color("#59645c"), 1.0)
var stone_light := _material(Color("#7b887b"), 0.95)
var leaf_dark := _material(Color("#183d32"), 1.0)
var leaf_mid := _material(Color("#2f6549"), 0.95)
var leaf_warm := _material(Color("#678654"), 0.9)
var mist := _material(Color(0.58, 0.78, 0.75, 0.18), 0.25, true)
var gold := _emissive_material(Color("#ffd678"), 2.2)


func _ready() -> void:
	_build_world()
	_build_player_and_camera()
	_build_ui()
	_set_objective("FOLLOW THE FIREFLIES  ·  FIND THE OLD NEST")


func _process(delta: float) -> void:
	_time += delta
	for index in _wisp_nodes.size():
		var wisp := _wisp_nodes[index]
		if is_instance_valid(wisp):
			wisp.position.y += sin(_time * 2.4 + index) * 0.0025
			wisp.rotation.y += delta * 1.6
	_update_progress()
	_update_checkpoint()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_R:
		player.reset_to_spawn()


func _build_world() -> void:
	_build_lighting()
	_build_background()
	# Beat 1: sheltered forest floor and readable warm-up jumps.
	_ground_bank(Vector3(3, -0.8, 0), Vector3(25, 1.6, 5.2))
	_log_platform(Vector3(18, 1.0, 0), 6.0, -7.0)
	_rock_platform(Vector3(25, 2.4, 0), Vector3(4.6, 1.2, 4.2))
	_log_platform(Vector3(31, 3.4, 0), 5.5, 8.0)
	_ground_bank(Vector3(38, 0.0, 0), Vector3(9, 1.4, 5.0))
	# Beat 2: a high launch and broad glide over the blue ravine.
	_rock_platform(Vector3(44, 2.1, 0), Vector3(4.0, 1.0, 4.0))
	_rock_platform(Vector3(49, 4.2, 0), Vector3(3.6, 1.0, 3.8))
	_log_platform(Vector3(55, 6.0, 0), 7.0, -4.0)
	_ground_bank(Vector3(68, 0.0, 0), Vector3(12, 1.5, 5.0))
	# Beat 3: waterfall stones, then a final climb into sunlight.
	_rock_platform(Vector3(77, 1.3, 0), Vector3(3.2, 1.0, 3.6))
	_rock_platform(Vector3(82, 2.5, 0), Vector3(3.0, 1.0, 3.5))
	_rock_platform(Vector3(87, 3.6, 0), Vector3(3.2, 1.0, 3.6))
	_ground_bank(Vector3(96, 0.5, 0), Vector3(14, 2.2, 5.0))
	_log_platform(Vector3(105, 3.2, 0), 6.0, 7.0)
	_rock_platform(Vector3(112, 5.0, 0), Vector3(7.5, 1.4, 4.5))
	_build_water()
	_build_landmarks()
	_build_wisps()
	_add_reset_volume(Vector3(58, -3.0, 0), Vector3(130, 2, 12))
	_add_finish(Vector3(113.5, 6.2, 0))


func _build_lighting() -> void:
	var environment := WorldEnvironment.new()
	var env := Environment.new()
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color("#173447")
	sky_material.sky_horizon_color = Color("#90aa91")
	sky_material.ground_bottom_color = Color("#132821")
	sky_material.ground_horizon_color = Color("#526b57")
	var sky := Sky.new()
	sky.sky_material = sky_material
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#9bb7a5")
	env.ambient_light_energy = 0.72
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.fog_enabled = true
	env.fog_light_color = Color("#8caea1")
	env.fog_density = 0.006
	env.fog_sky_affect = 0.45
	environment.environment = env
	add_child(environment)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -32, -8)
	sun.light_color = Color("#ffd39a")
	sun.light_energy = 1.7
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 75.0
	add_child(sun)


func _build_background() -> void:
	# True 3D layers: the camera's perspective gives each depth a different travel rate.
	for layer in 3:
		var depth := -12.0 - layer * 10.0
		var scale_factor := 1.0 + layer * 0.42
		for x in range(-15 + layer * 4, 135, 11 + layer * 3):
			_tree(Vector3(x, -0.8, depth), 7.0 * scale_factor, 1.0 * scale_factor, layer)
	# Soft distant land masses stop the horizon reading as an empty void.
	for x in range(-10, 140, 18):
		var mound := MeshInstance3D.new()
		var mesh := SphereMesh.new()
		mesh.radius = 7.5
		mesh.height = 9.0
		mound.mesh = mesh
		mound.position = Vector3(x, -3.8, -34)
		mound.scale = Vector3(1.7, 0.8, 0.7)
		mound.material_override = leaf_dark
		add_child(mound)


func _build_landmarks() -> void:
	# Rooted ancient tree at the opening.
	_tree(Vector3(-10, -0.1, -2.8), 12.5, 1.7, 0)
	for offset in [-2.0, 0.0, 2.0]:
		_log_visual(Vector3(-9.5 + offset * 0.35, 0.0, -2.3 + absf(offset) * 0.35), 4.8, 0.55, 66.0 + offset * 7.0, bark)
	# Waterfall is real geometry, separated from the traversable stones.
	var falls := MeshInstance3D.new()
	var falls_mesh := BoxMesh.new()
	falls_mesh.size = Vector3(7.0, 15.0, 0.25)
	falls.mesh = falls_mesh
	falls.position = Vector3(84, 9.5, -6.5)
	falls.material_override = mist
	add_child(falls)
	for i in 7:
		_rock_visual(Vector3(79.5 + i * 1.5, 15.5 + sin(i) * 0.7, -6.0), Vector3(2.5, 1.8, 2.0), stone)
	# Nest goal: interlocked branches and a warm beacon.
	for i in 8:
		_log_visual(Vector3(113.5, 6.25 + sin(i * 1.7) * 0.12, -0.2), 3.4, 0.16, i * 22.5, bark_light)
	var beacon := OmniLight3D.new()
	beacon.position = Vector3(113.5, 7.2, 0)
	beacon.light_color = Color("#ffd687")
	beacon.light_energy = 4.0
	beacon.omni_range = 7.0
	add_child(beacon)


func _build_water() -> void:
	_water_material = _material(Color(0.12, 0.48, 0.52, 0.72), 0.18, true)
	var water := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(92, 0.25, 8)
	water.mesh = mesh
	water.position = Vector3(61, -1.85, 0)
	water.material_override = _water_material
	add_child(water)


func _build_wisps() -> void:
	var positions := [Vector3(14, 2.3, 0), Vector3(31, 5.2, 0), Vector3(55, 8.0, 0), Vector3(72, 2.3, 0), Vector3(87, 5.5, 0), Vector3(105, 5.2, 0)]
	for index in positions.size():
		var area := Area3D.new()
		area.name = "Firefly%d" % (index + 1)
		area.position = positions[index]
		area.collision_layer = 0
		area.collision_mask = 2
		var shape := CollisionShape3D.new()
		var sphere_shape := SphereShape3D.new()
		sphere_shape.radius = 0.8
		shape.shape = sphere_shape
		area.add_child(shape)
		var glow := MeshInstance3D.new()
		var sphere := SphereMesh.new()
		sphere.radius = 0.2
		sphere.height = 0.4
		glow.mesh = sphere
		glow.material_override = gold
		area.add_child(glow)
		var light := OmniLight3D.new()
		light.light_color = Color("#ffd678")
		light.light_energy = 2.0
		light.omni_range = 3.0
		area.add_child(light)
		area.body_entered.connect(_on_wisp_collected.bind(area))
		add_child(area)
		_wisp_nodes.append(area)


func _build_player_and_camera() -> void:
	player = PLAYER_SCENE.instantiate()
	player.position = Vector3(-6, 0.1, 0)
	add_child(player)
	var camera := Camera3D.new()
	camera.name = "PlayerCamera"
	camera.position = Vector3(-5, 4.8, 15.5)
	camera.fov = 50.0
	camera.current = true
	camera.set_script(CAMERA_SCRIPT)
	camera.target = player
	camera.min_height = 4.5
	camera.min_x = -5.0
	camera.max_x = 113.0
	add_child(camera)


func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var panel := ColorRect.new()
	panel.position = Vector2(28, 26)
	panel.size = Vector2(790, 146)
	panel.color = Color(0.025, 0.07, 0.06, 0.76)
	layer.add_child(panel)
	var box := VBoxContainer.new()
	box.position = Vector2(26, 18)
	box.add_theme_constant_override("separation", 5)
	panel.add_child(box)
	var title := _label("THE OLD WATERFALL  ·  PLAYABLE PROTOTYPE", 25, Color("#f1d39a"))
	box.add_child(title)
	objective_label = _label("", 18, Color("#e8eee5"))
	box.add_child(objective_label)
	progress_label = _label("FIREFLIES  0 / 6", 16, Color("#ffd678"))
	box.add_child(progress_label)
	message_label = _label("A/D OR ARROWS  MOVE   ·   SPACE/UP  JUMP, FLAP, GLIDE   ·   S/DOWN  DIVE   ·   R  RESET", 14, Color("#a9cbbb"))
	box.add_child(message_label)


func _ground_bank(position: Vector3, size: Vector3) -> void:
	_add_collision_box(position, size)
	for x in range(int(position.x - size.x * 0.5), int(position.x + size.x * 0.5) + 1, 2):
		_rock_visual(Vector3(x, position.y + size.y * 0.15, -0.15 + sin(x) * 0.22), Vector3(2.6, size.y * 0.9, 4.5), stone if x % 4 else stone_light)
		var cap := MeshInstance3D.new()
		var cap_mesh := SphereMesh.new()
		cap_mesh.radius = 1.35
		cap_mesh.height = 0.42
		cap.mesh = cap_mesh
		cap.position = Vector3(x, position.y + size.y * 0.52, 0)
		cap.scale = Vector3(1.0, 0.5, 1.65)
		cap.material_override = moss if x % 4 else moss_light
		add_child(cap)


func _log_platform(position: Vector3, length: float, angle: float) -> void:
	_add_collision_box(position, Vector3(length * 0.9, 0.8, 3.4))
	_log_visual(position, length, 0.72, 90.0 + angle, bark_light)
	for x_offset in [-length * 0.28, 0.0, length * 0.28]:
		var moss_patch := MeshInstance3D.new()
		var mesh := SphereMesh.new()
		mesh.radius = 0.72
		mesh.height = 0.22
		moss_patch.mesh = mesh
		moss_patch.position = position + Vector3(x_offset, 0.43, 0)
		moss_patch.scale = Vector3(1.35, 0.5, 1.1)
		moss_patch.material_override = moss_light
		add_child(moss_patch)


func _rock_platform(position: Vector3, size: Vector3) -> void:
	_add_collision_box(position, size)
	_rock_visual(position, size * Vector3(1.08, 1.12, 1.06), stone)
	_rock_visual(position + Vector3(-size.x * 0.26, size.y * 0.38, 0.15), size * Vector3(0.65, 0.55, 0.92), stone_light)
	var cap := MeshInstance3D.new()
	var cap_mesh := SphereMesh.new()
	cap_mesh.radius = size.x * 0.34
	cap_mesh.height = 0.22
	cap.mesh = cap_mesh
	cap.position = position + Vector3(0, size.y * 0.58, 0)
	cap.scale = Vector3(1.25, 0.45, size.z / size.x)
	cap.material_override = moss_light
	add_child(cap)


func _tree(position: Vector3, height: float, width: float, layer: int) -> void:
	var trunk_material: Material = bark if layer == 0 else _material(Color("#284034").darkened(layer * 0.08), 1.0)
	var crown_material: Material = [leaf_mid, leaf_dark, _material(Color("#213b38"), 1.0)][mini(layer, 2)]
	_log_visual(position + Vector3(0, height * 0.43, 0), height * 0.82, width, 0, trunk_material)
	for offset in [Vector3(-width, height * 0.78, 0), Vector3(width * 0.8, height * 0.88, 0), Vector3(0, height, 0)]:
		var crown := MeshInstance3D.new()
		var sphere := SphereMesh.new()
		sphere.radius = width * 1.75
		sphere.height = width * 3.0
		crown.mesh = sphere
		crown.position = position + offset
		crown.scale = Vector3(1.45, 1.0, 0.85)
		crown.material_override = crown_material
		add_child(crown)


func _log_visual(position: Vector3, length: float, radius: float, angle_z: float, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius * 0.86
	mesh.bottom_radius = radius
	mesh.height = length
	mesh.radial_segments = 10
	mesh_instance.mesh = mesh
	mesh_instance.position = position
	mesh_instance.rotation_degrees.z = angle_z
	mesh_instance.material_override = material
	add_child(mesh_instance)


func _rock_visual(position: Vector3, size: Vector3, material: Material) -> void:
	var rock := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.5
	sphere.height = 1.0
	sphere.radial_segments = 10
	sphere.rings = 6
	rock.mesh = sphere
	rock.position = position
	rock.scale = size
	rock.rotation_degrees = Vector3(0, fmod(position.x * 19.0, 35.0), fmod(position.x * 7.0, 12.0) - 6.0)
	rock.material_override = material
	add_child(rock)


func _add_collision_box(position: Vector3, size: Vector3) -> void:
	var body := StaticBody3D.new()
	body.position = position
	var shape_node := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	shape_node.shape = shape
	body.add_child(shape_node)
	add_child(body)


func _add_reset_volume(position: Vector3, size: Vector3) -> void:
	var area := Area3D.new()
	area.position = position
	area.collision_layer = 0
	area.collision_mask = 2
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	area.add_child(collision)
	area.body_entered.connect(func(body: Node3D) -> void:
		if body == player:
			player.reset_to_spawn()
			_flash_message("THE RIVER RETURNS YOU TO THE LAST PERCH")
	)
	add_child(area)


func _add_finish(position: Vector3) -> void:
	var area := Area3D.new()
	area.position = position
	area.collision_layer = 0
	area.collision_mask = 2
	var collision := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 2.0
	collision.shape = shape
	area.add_child(collision)
	area.body_entered.connect(func(body: Node3D) -> void:
		if body == player and not _complete:
			_complete = true
			_set_objective("DEMO COMPLETE  ·  THE OLD NEST IS HOME AGAIN")
			message_label.text = "You reached the goal with %d of 6 fireflies. Press R to replay from the final perch." % _wisps
	)
	add_child(area)


func _on_wisp_collected(body: Node3D, area: Area3D) -> void:
	if body != player or not is_instance_valid(area):
		return
	_wisps += 1
	_wisp_nodes.erase(area)
	area.queue_free()
	progress_label.text = "FIREFLIES  %d / 6" % _wisps
	_flash_message("FIREFLY FOUND  ·  %d REMAIN" % (6 - _wisps))


func _update_checkpoint() -> void:
	var checkpoints := [
		{"x": 35.0, "spawn": Vector3(35, 1.0, 0), "text": "CLIMB TO THE HIGH LOG, THEN HOLD GLIDE"},
		{"x": 67.0, "spawn": Vector3(66, 1.0, 0), "text": "CROSS THE WATERFALL STEPPING STONES"},
		{"x": 94.0, "spawn": Vector3(94, 1.8, 0), "text": "ONE LAST CLIMB  ·  REACH THE OLD NEST"},
	]
	if _checkpoint < checkpoints.size() and player.position.x >= checkpoints[_checkpoint].x:
		var data: Dictionary = checkpoints[_checkpoint]
		player.set_respawn_position(data.spawn)
		_set_objective(data.text)
		_checkpoint += 1


func _update_progress() -> void:
	if _complete:
		return
	var percent := clampi(int(((player.position.x + 6.0) / (LEVEL_END + 6.0)) * 100.0), 0, 100)
	progress_label.text = "FIREFLIES  %d / 6     ·     JOURNEY  %d%%" % [_wisps, percent]


func _set_objective(text: String) -> void:
	objective_label.text = text


func _flash_message(text: String) -> void:
	message_label.text = text
	get_tree().create_timer(2.2).timeout.connect(func() -> void:
		if is_instance_valid(message_label) and not _complete:
			message_label.text = "A/D OR ARROWS  MOVE   ·   SPACE/UP  JUMP, FLAP, GLIDE   ·   S/DOWN  DIVE   ·   R  RESET"
	)


func _label(text: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label


static func _material(color: Color, roughness: float, transparent := false) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	if transparent:
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return material


static func _emissive_material(color: Color, energy: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.emission_enabled = true
	material.emission = color
	material.emission_energy_multiplier = energy
	return material
